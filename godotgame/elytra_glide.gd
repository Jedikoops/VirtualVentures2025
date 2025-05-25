extends CharacterBody2D

# Constants
const GRAVITY = 600.0
const DRAG = 0.1
const MAX_SPEED = 400.0
const GLIDE_ACCELERATION = 300.0
const LIFT_ANGLE_LIMIT = 45 # degrees

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var acceleration: Vector2 = Vector2.ZERO

@export var friction: = 10000
@export var air_friction: = 300

@onready var icon: Sprite2D = $Sprite2D

# Variables
var glide_angle = 20.0 # degrees downward by default
var is_gliding = false

func _physics_process(delta: float) -> void:
	# Collision with Area2D layer 2
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			is_gliding = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and is_on_floor():
		velocity.x = direction * SPEED
		is_gliding = false
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		is_gliding = false
	else:
		
		if is_gliding:
			icon.rotation = velocity.angle()
			icon.rotation_degrees += 400*delta*direction
			velocity = Vector2.RIGHT.rotated(icon.rotation) * velocity.length()
			velocity += 0.6 * get_gravity() * delta
			apply_friction(delta)
		else:
			velocity += get_gravity() * delta

	move_and_slide()


func apply_friction(delta) -> void:
	var friction_amount: = friction
	if not is_on_floor(): friction_amount = air_friction
	velocity.x = move_toward(velocity.x, 0.0, friction_amount * delta)


func _on_die() -> void:
	queue_free()
