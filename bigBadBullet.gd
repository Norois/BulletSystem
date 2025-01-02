extends Sprite2D

@onready var bullet_system: Node2D = get_parent().get_node("ExperimentalBulletSystem") as ExperimentalBulletSystem

func _ready() -> void:
	shoot()


func shoot():
	for j in range(0, 10):
		for i in range(0, 1000):
			bullet_system.spawn_bullet(position, Vector2.UP.rotated(deg_to_rad(0.036 * i * j)), 80)
		await get_tree().create_timer(1).timeout
