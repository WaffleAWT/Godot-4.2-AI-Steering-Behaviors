extends CharacterBody2D

#Signals
signal died

#Data
const MAX_FORCE : float = 0.02
const MAX_SPEED : float = 80.0
const ACCELERATION : float = 500.0
const FRICTION : float = 500.0
const AVOIDANCE_FORCE : float = 1000.0

var enemy = null

@onready var start_position : Vector2 = global_position

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_rays : Node2D = $CollisionRays
@onready var enemy_detection_zone : Area2D = $EnemyDetectionZone
@onready var sword : Node2D = $Sword
@onready var sword_animator : AnimationPlayer = $SwordAnimator
@onready var soft_collision : Area2D = $SoftCollision

func _physics_process(delta):
	#Prevents overlapping
	if soft_collision.is_colliding():
		var areas = soft_collision.get_overlapping_areas()
		for area in areas:
			velocity += soft_collision.get_push_vector() * delta * soft_collision.soft_collision_chance
	
	move_and_slide()

func steer(target): #Steering behaviour instead of walking straight to target
	var desired_velocity : Vector2 = Vector2(target - global_position).normalized() * MAX_SPEED
	var steer_amount : Vector2 = desired_velocity - velocity
	var target_velocity : Vector2 = velocity + (steer_amount * MAX_FORCE)
	return target_velocity

func avoid_obstacles() -> Vector2: #Obstacle avoidance logic
	collision_rays.rotation = velocity.angle()
	
	for raycast in collision_rays.get_children():
		raycast.target_position.x = velocity.length()
		if raycast.is_colliding():
			var obstacle : PhysicsBody2D = raycast.get_collider()
			return (position + velocity - obstacle.position).normalized() * AVOIDANCE_FORCE
	
	return Vector2.ZERO
