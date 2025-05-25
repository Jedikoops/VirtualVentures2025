extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var movingRight: bool = true

func _physics_process(delta: float) -> void:
	var effectiveSpeed = SPEED
	if movingRight:
		effectiveSpeed *= -1.0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = effectiveSpeed
	move_and_slide()
	if is_on_wall():
		movingRight = !movingRight
