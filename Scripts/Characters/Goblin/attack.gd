extends State

#Data
var orbit_radius : float = 32.0
var orbit_speed : float = 1.0
var orbit_speed_multiplier : float = 25.0
var current_angle : float

#Refrences
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	#Pick a random angle to circle the enemy
	var random_angle : float = randf_range(0.0, 360.0)
	current_angle = random_angle

func physics_update(delta):
	#If the distance is big chase the enemy
	if owner.enemy_detection_zone.can_see_enemy():
		if !owner.global_position.distance_to(owner.enemy_detection_zone.enemy.global_position) <= 24.0:
			state_machine.transition_to("Chase")
		else: 
			#Circle logic
			current_angle += deg_to_rad(orbit_speed * delta)
			
			var new_position : Vector2 = Vector2(cos(current_angle), sin(current_angle)) * orbit_radius
			var target_position : Vector2 = owner.enemy_detection_zone.enemy.global_position + new_position
			
			owner.velocity = (target_position - owner.position).normalized() * orbit_speed_multiplier
		
		#Random attacks timer
		if timer.is_stopped():
			timer.start(randi_range(1, 3))
		
		#Animation
		owner.animator.flip_h = owner.enemy_detection_zone.enemy.global_position < owner.global_position
		owner.sword.scale.x = -1 if owner.animator.flip_h else 1
	else:
		state_machine.transition_to("Idle")

func _on_timer_timeout():
	if owner.animator.flip_h:
		owner.sword_animator.play("AttackFlip")
	else:
		owner.sword_animator.play("AttackNoFlip")
