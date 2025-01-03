extends Node2D

signal hit
@export var lives = 2
@export var bombs = 3
@export var speed = 300
var canMove = true
var isBeingHit : bool = false

func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var vector := Vector2()
	var showHitbox = false
	var movedToSide = false
	speed = 300
	
	if(!canMove):
		return
	
	# Handle the slow mode when pressing shift
	if(Input.is_action_pressed("slow")):
		speed = 150
		showHitbox = true
	
	# handle movement direction
	if(Input.is_action_pressed("up")):
		if(!global_position.y < -314): # Don't move over the edge
			vector += Vector2.UP.rotated(deg_to_rad(0))
	if(Input.is_action_pressed("down")):
		if(!global_position.y > 314): # Don't move over the edge
			vector += Vector2.UP.rotated(deg_to_rad(180))
	if(Input.is_action_pressed("left")):
		if(!global_position.x < -566): # Don't move over the edge
			vector += Vector2.UP.rotated(deg_to_rad(270))
		# Tilt to left
		movedToSide = true
		if(rad_to_deg($Sprite2D.rotation) > -20):
			$Sprite2D.rotation = move_toward($Sprite2D.rotation, -20, 2 * delta)
	if(Input.is_action_pressed("right")):
		if(!global_position.x > 566): # Don't move over the edge
			vector += Vector2.UP.rotated(deg_to_rad(90))
		# Tilt to right
		movedToSide = true
		if(rad_to_deg($Sprite2D.rotation) < 20):
			$Sprite2D.rotation = move_toward($Sprite2D.rotation, 20, 2 * delta)
	
	# Tilting
	if(!movedToSide):
		$Sprite2D.rotation = move_toward($Sprite2D.rotation, 0, 2 * delta)
	
	# Don't move when holding 2 oposing keys
	if(vector.is_zero_approx() == false):
		# Don't move faster diagnally
		position += vector.normalized() * speed * delta
	
	# Show the hitbox if holding shift
	if(showHitbox):
		$Sprite2D/Hitbox.visible = true;
	else:
		$Sprite2D/Hitbox.visible = false;
	

func _die(area_rid: RID, area: Area2D):
	Global.BulletSystemEx.remove_this(area_rid)
	hit.emit()
	if(isBeingHit):
		return
	isBeingHit = true
	$HitboxArea.set_deferred("monitoring", false)
	for n in 30:
		canMove = false
		$deathWave.visible = true
		$deathWave.scale.x += 0.40
		$deathWave.scale.y += 0.40
		$deathWave.modulate.a -= 0.1
		await get_tree().create_timer(0.01).timeout
		if(n == 15):
			position = Vector2(0, 367)
	
	rotation = deg_to_rad(0)
	$Sprite2D/Hitbox.visible = false
	
	for n in 20:
		position += Vector2.UP.rotated(deg_to_rad(0)) * 6
		await get_tree().create_timer(0.01).timeout
	
	canMove = true
	lives -= 1
	bombs = 2
	
	isBeingHit = false
	$deathWave.visible = false
	$deathWave.scale.x = 1
	$deathWave.scale.y = 1
	$deathWave.modulate.a = 1
	
	await get_tree().create_timer(3).timeout
	$HitboxArea.set_deferred("monitoring", true)
