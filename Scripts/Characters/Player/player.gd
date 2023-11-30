extends CharacterBody2D

#Data
@export_group("Movement")
@export var max_speed : float = 80.0
@export var acceleration : float = 500.0
@export var friction : float = 500.0

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var hand : Node2D = $Hand
@onready var soft_collision : Area2D = $SoftCollision
@onready var sword_animator : AnimationPlayer = $SwordAnimator

func _physics_process(delta):
	#Movement direction vector
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	
	#Check if we're pressing input
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		animator.play("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animator.play("Idle")
	
	#Animation
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_position.x > 0 and animator.flip_h:
		animator.flip_h = false
	elif mouse_position.x < 0 and not animator.flip_h:
		animator.flip_h = true
	
	hand.rotation = mouse_position.angle()
	if hand.scale.y == 1 and mouse_position.x < 0:
		hand.scale.y = -1
	elif hand.scale.y == -1 and mouse_position.x > 0:
		hand.scale.y = 1
	
	#Prevent overlapping
	if soft_collision.is_colliding():
		var areas = soft_collision.get_overlapping_areas()
		for area in areas:
			velocity += soft_collision.get_push_vector() * delta * soft_collision.soft_collision_chance
	
	move_and_slide()

func _input(event):
	#Attack input logic
	if event.is_action_pressed("LMB"):
		sword_animator.play("Attack")
