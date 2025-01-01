extends Node
class_name BulletSystem

var PlayerBulletHolder: Node
var EnemyBulletHolder: Node

var PreloadPlayerBullets: int = 200
var PreloadEnemyBullets: int = 1000

func _ready() -> void:
	PlayerBulletHolder = $PlayerBullets
	EnemyBulletHolder = $EnemyBullets
	
