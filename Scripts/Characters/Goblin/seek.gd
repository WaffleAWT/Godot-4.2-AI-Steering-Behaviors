extends State

#Data
var wander_range : int = 64
var wander_target_range : int = 4
var target_position : Vector2

#Refrences
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	#Picks a random position to move to withing our wander range
	update_target_position()

func physics_update(delta):
	seek_enemy()
	
	#Check if we reached the target position
	if owner.global_position.distance_to(target_position) <= wander_target_range:
		apply_friction(delta)
		owner.animator.play("Idle")
		if timer.is_stopped():
			start_timer()
	else:
		#Steer while seeking "Movement logic"
		owner.velocity = owner.velocity.move_toward(owner.steer(target_position) + owner.avoid_obstacles(), owner.ACCELERATION * delta)
		owner.velocity = owner.velocity.clamp(Vector2(-owner.MAX_SPEED, -owner.MAX_SPEED), Vector2(owner.MAX_SPEED, owner.MAX_SPEED))
		
		owner.animator.play("Run")
		
		#Look where moving
		owner.animator.flip_h = owner.velocity.x < 0
		owner.sword.scale.x = -1 if owner.animator.flip_h else 1
		if timer.is_stopped():
			start_timer()

func apply_friction(delta):
	owner.velocity = owner.velocity.move_toward(Vector2.ZERO, owner.FRICTION * delta)

func update_target_position(): #Picks a random position to move to
	var target_vector : Vector2 = Vector2(randi_range(-wander_range, wander_range), randi_range(-wander_range, wander_range))
	target_position = owner.start_position + target_vector

func seek_enemy():
	if owner.enemy_detection_zone.can_see_enemy():
		state_machine.transition_to("Chase")

func start_timer():
	timer.wait_time = randi_range(1, 5)
	timer.start()

func _on_timer_timeout(): #Goes back to idle
	state_machine.transition_to("Idle")
