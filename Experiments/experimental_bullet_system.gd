extends Node2D
class_name ExperimentalBulletSystem

var bullets: Array = []
@onready var shared_area: Node = $Area2D as Area2D

var bullets_stay_here: Rect2 = Rect2(-300, -300, 600, 600)

@export var bullet_image: Texture2D

func _ready() -> void:
	Global.BulletSystemEx = self

func _exit_tree() -> void:
	for bullet in bullets:
		PhysicsServer2D.free_rid((bullet as Bullet).shape_id)
	bullets.clear()

func _draw() -> void:
	var offset = bullet_image.get_size() / 2.0
	for i in range(0, bullets.size()):
		var bullet = bullets[i]
		draw_texture(
			bullet_image,
			bullet.current_position - offset
		)

func _process(delta: float) -> void:
	var used_transform = Transform2D()
	var bullets_destruct = []
	
	for i in range(0, bullets.size()):
		
		var bullet = bullets[i] as Bullet
		
		if(!bullets_stay_here.has_point(bullet.current_position)):
			bullets_destruct.append(bullet)
			continue
		
		var offset: Vector2 = (
			bullet.movement_vector.normalized() * bullet.speed * delta
		)
		
		bullet.current_position += offset
		used_transform.origin = bullet.current_position
		PhysicsServer2D.area_set_shape_transform(
			shared_area.get_rid(), i, used_transform
		)
	
	for bullet in bullets_destruct:
		print(bullet.shape_id)
		print(bullets.find(bullet))
		PhysicsServer2D.free_rid(bullet.shape_id)
		bullets.erase(bullet)
	
	queue_redraw()


func spawn_bullet(spawnPos: Vector2, moveVec: Vector2, speed: float):
	var bullet: Bullet = Bullet.new()
	bullet.current_position = spawnPos
	bullet.movement_vector = moveVec
	bullet.speed = speed
	
	bullet_collision(bullet)
	
	bullets.append(bullet)

func bullet_collision(bullet: Bullet):
	
	var Transform: Transform2D = Transform2D(0, bullet.current_position)
	
	var shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape, 8)
	
	PhysicsServer2D.area_add_shape(
		shared_area.get_rid(), shape, Transform
	)
	
	bullet.shape_id = shape
	

func remove_this(bullet_rid: RID):
	pass
