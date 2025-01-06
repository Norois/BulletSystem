extends Node2D
class_name ExperimentalBulletSystem

# All the bullets in game
var bullets: Array = []

# Area2D to which all bullets are connected
@onready var shared_area: Node = $Area2D as Area2D

# If a bullet goes outside of here, its deleted, placeholder values
var bullets_stay_here: Rect2 = Rect2(-500, -500, 1000, 1000)

# Texture of the bullet
@export var bullet_image: Texture2D

# Should hold the bullet objects with thier RID as key
var bulletDict: Dictionary

# Bullets to be destroyed in the next _process iteration
var bullets_destruct = []

func _ready() -> void:
	# Global setting so you can call stuff from here from other scripts
	Global.BulletSystemEx = self

func _exit_tree() -> void:
	# If the node is no longer in game remove all bullets
	for bullet in bullets:
		PhysicsServer2D.free_rid((bullet as Bullet).shape_id)
	bullets.clear()

func _draw() -> void:
	# Offsets the image to make sure its at the center of the collision
	var offset = bullet_image.get_size() / 2.0
	
	# Draws all bullets every frame
	for i in range(0, bullets.size()):
		var bullet = bullets[i]
		draw_texture(
			bullet_image,
			bullet.current_position - offset
		)

func _process(delta: float) -> void:
	# I'm unsure myself
	var used_transform = Transform2D()
	
	# For each bullet in the bullet array do the following
	for i in range(0, bullets.size()):
		
		# To easier acces the specifc bullet object later
		var bullet = bullets[i] as Bullet
		
		# If a bullet is beyond the Rect2D specified ealier, delete it
		if(!bullets_stay_here.has_point(bullet.current_position)):
			bullets_destruct.append(bullet)
			continue
		
		# Calculate how long it should be moved
		var offset: Vector2 = (
			bullet.movement_vector.normalized() * bullet.speed * delta
		)
		
		# Apply the movement of the object and the collision shape
		bullet.current_position += offset
		used_transform.origin = bullet.current_position
		PhysicsServer2D.area_set_shape_transform(
			shared_area.get_rid(), i, used_transform
		)
	
	# Delete all bullets that are to be deleted acording to the bullets_destruct array
	for bullet in bullets_destruct:
		PhysicsServer2D.free_rid(bullet.shape_id)
		bullets.erase(bullet)
		bulletDict.erase(bullet.shape_id)
	
	# Clears the array for destroying bullets, as it cannot be local variable
	bullets_destruct = []
	
	# So all sprites allign with thier position, redraw them
	queue_redraw()

func spawn_bullet(spawnPos: Vector2, moveVec: Vector2, speed: float):
	# Basic setup of the bullet object, apply the values
	var bullet: Bullet = Bullet.new()
	bullet.current_position = spawnPos
	bullet.movement_vector = moveVec
	bullet.speed = speed
	
	# Add the actual collision to the bullet
	bullet_collision(bullet)
	
	# Add the bullet to the bullets array
	bullets.append(bullet)
	
	# Add the bullet to the dictionary to be able to find it outside of this loop
	var addThis: Dictionary = {
		bullet.shape_id : bullet
	}
	bulletDict.merge(addThis, true) # I dunno is there a better way to add to stuff to a dictionary

func bullet_collision(bullet: Bullet):
	
	var Transform: Transform2D = Transform2D(0, bullet.current_position)
	
	# Make the shape of the bullet
	var shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape, 8)
	
	# Add the shape to the Physics Engine
	PhysicsServer2D.area_add_shape(
		shared_area.get_rid(), shape, Transform
	)
	
	# Set the ID so it can be accessed later
	bullet.shape_id = shape

func remove_this(bullet_rid: RID):
	# This should get the bullet object and add it to the destruction array
	var bullet = bulletDict.get(bullet_rid)
	
	bullets_destruct.append(bullet)
	
	print("Deleted thing")
