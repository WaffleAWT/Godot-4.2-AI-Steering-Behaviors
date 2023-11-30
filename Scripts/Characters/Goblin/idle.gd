extends State

#Refrences
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	#Animation
	owner.animator.play("Idle")
	#Start the timer to wander and seek enemies
	start_timer()

func physics_update(delta):
	seek_enemy()
	owner.velocity = owner.velocity.move_toward(Vector2.ZERO, owner.FRICTION * delta)

func seek_enemy():
	if owner.enemy_detection_zone.can_see_enemy():
		state_machine.transition_to("Chase")

func start_timer():
	timer.wait_time = randi_range(1, 5)
	timer.start()

func _on_timer_timeout():
	state_machine.transition_to("Seek")
