extends CharacterBody2D

enum STATE {DIG, MOVE}
@export var state: = STATE.MOVE

const SPEED = 300.0
var cur_speed
const JUMP_VELOCITY = -400.0
@export var friction: = 10000
@export var air_friction: = 10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if state == STATE.DIG:
		_try_dig(delta)
	if state == STATE.MOVE:
		_try_move(delta)
	move_and_slide()

func _try_dig(delta):
	velocity = Vector2.RIGHT.rotated(global_rotation) * SPEED
	rotation = rotate_toward(rotation, (get_global_mouse_position() - self.position).angle(),  10 * delta)
	
func	 _try_move(delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	if(velocity.length() > SPEED) or not direction:
		apply_friction(delta)
	else:
		velocity.x = direction * SPEED
	velocity += get_gravity() * delta

func digbox_collide(area: Area2D) -> void:
	print("dig")
	state = STATE.DIG
	rotation = velocity.angle()


func _on_area_2d_area_exited(area: Area2D) -> void:
	state = STATE.MOVE

func apply_friction(delta) -> void:
	var friction_amount: = friction
	if not is_on_floor(): friction_amount = air_friction
	velocity.x = move_toward(velocity.x, 0.0, friction_amount * delta)
