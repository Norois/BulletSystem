extends Sprite2D

@onready var bullet_system: Node2D = Global.BulletSystemEx

func _ready() -> void:
	shoot()


func shoot():
	
	for i in range(0, 10):
		bullet_system.spawn_bullet(position, Vector2.UP.rotated(deg_to_rad(36 * i)), 80)
