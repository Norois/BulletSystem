extends Node2D
var count: int = 0

#func _process(_delta: float) -> void:
	#if(Input.is_action_pressed("confirm")):
		#if(count == 3):
			#var bullet = PlayerBullet._CreatePlayerBullet(global_position.x, global_position.y - 20, 800.0, 0, 2.0)
			#Global.reference_holder.player_bullets.add_child(bullet)
			#count = 0
		#else:
			#count += 1
