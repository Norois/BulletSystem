extends Node2D
class_name Bullet

@export var Angle: float
@export var Speed: float

var texture: Texture2D = load("res://Bullet/bullet.png")

func _physics_process(delta: float) -> void:
	global_position += Vector2.UP.rotated(deg_to_rad(Angle)) * Speed * delta

func _draw() -> void:
	draw_texture(texture, Vector2(-8, -8))
