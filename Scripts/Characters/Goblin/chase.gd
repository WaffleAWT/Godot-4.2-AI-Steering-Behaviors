extends State

func physics_update(delta):
	#Check if we're in attack radius and if not move
	if owner.enemy_detection_zone.can_see_enemy():
		if !owner.global_position.distance_to(owner.enemy_detection_zone.enemy.global_position) <= 32.0:
			owner.velocity = owner.velocity.move_toward(owner.steer(owner.enemy_detection_zone.enemy.global_position) + owner.avoid_obstacles(), owner.ACCELERATION * delta)
			owner.velocity = owner.velocity.clamp(Vector2(-owner.MAX_SPEED, -owner.MAX_SPEED), Vector2(owner.MAX_SPEED, owner.MAX_SPEED))
			
			#Animation
			owner.animator.flip_h = owner.enemy_detection_zone.enemy.global_position < owner.global_position
			owner.sword.scale.x = -1 if owner.animator.flip_h else 1
		else:
			state_machine.transition_to("Attack")
	else:
		state_machine.transition_to("Seek")
	
	#Animation
	if owner.velocity != Vector2.ZERO:
		owner.animator.play("Run")
	else:
		owner.animator.play("Idle")
