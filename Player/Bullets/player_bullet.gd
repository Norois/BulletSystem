extends Node2D
class_name PlayerBullet
var Damage: float
var Angle: float
var Speed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2.UP.rotated(deg_to_rad(Angle)) * Speed * delta

static func _CreatePlayerBullet(x: float, y: float, speed: float, angle: float, damage: float):
	var scene = load("res://Player/Bullets/player_bullet.tscn")
	var instance = scene.instantiate()
	instance.global_position.x = x
	instance.global_position.y = y
	instance.Damage = damage
	instance.Angle = angle
	instance.Speed = speed
	return instance
