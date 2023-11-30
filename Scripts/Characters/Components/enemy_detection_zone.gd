extends Area2D

var enemy = null

func can_see_enemy(): #Returns true if we can see the enemy and false if not
	return enemy != null

func _on_body_entered(body):
	if enemy == null:
		enemy = body

func _on_body_exited(_body):
	enemy = null
