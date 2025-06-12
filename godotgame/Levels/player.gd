extends CharacterBody2D

enum STATE {MOVE, CLIMB, HIT, SWIM, FLY, DIG}
@export var state: = STATE.MOVE

const CHECKPOINT = preload("res://Checkpoint_No_Flag.png")

const SPEED = 100.0
const CLIMB_SPEED = 80.0
const SWIM_SPEED = 80.0
const JUMP_VELOCITY = 280.0

const FRICTION: = 10000
const AIR_FRICTION: = 300

var gravity_mult:float
var climbing: bool = false
var swimming: bool = false

var can_climb: bool = false
var can_swim: bool = false
var can_fly: bool = false

var checkpoint = 0
var checkpoint_pos: Vector2
@export var WIN_CHECKPOINT = 3

@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var rig: Sprite2D = $CharacterRig
@onready var ui_player: player_ui = $CanvasLayer

func _ready() -> void:
	state = STATE.MOVE
	checkpoint_pos = global_position

func _physics_process(delta: float) -> void:
	var x_input = Input.get_axis("move_left", "move_right")
	var y_input = Input.get_axis("move_up", "move_down")
	var input = Vector2(x_input, y_input).normalized()
	
	if (state == STATE.CLIMB and not can_climb 
	or state == STATE.SWIM and not can_swim
	or state == STATE.FLY and not can_fly):
		state = STATE.MOVE
	
	match state:
		STATE.MOVE:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				jump()
			
			#attack can be here
			if x_input == 0:
				apply_friction(delta)
				anim.play("idle")
			else:
				velocity.x = x_input * SPEED
				anim.play("run")
				rig.scale.x = update_flip()
			
			if not is_on_floor():
				anim.play("jump")
				apply_gravity(delta)
			
			if Input.is_action_just_pressed("jump") and not is_on_floor():
				if climbing:
					state = STATE.CLIMB
				else:
					state = STATE.FLY
					reset_flip()
					#jump(JUMP_VELOCITY * 0.3) you can choose to jump or just take the falling
			
			move_and_slide()
		STATE.CLIMB:
			anim.play("climbing")
			velocity  = input * CLIMB_SPEED
			if velocity.x:
				rig.scale.x = update_flip()
			if Input.is_action_just_pressed("jump"):
					jump(JUMP_VELOCITY * 1.2)
					state = STATE.MOVE
					reset_flip()
			if is_on_floor():
				state = STATE.MOVE
			if not climbing:
				state = STATE.MOVE

			move_and_slide()
		STATE.SWIM:
			anim.play("swimming")
			reset_flip()
			if input.y <= 0:
				apply_gravity(delta, -0.6 * get_gravity())
			if input != Vector2.ZERO:
				velocity += input * SWIM_SPEED * 2 * delta
			rig.scale.x = update_flip()
			apply_friction(delta, Vector2.UP)
			velocity.x = sign(velocity.x) * minf(abs(velocity.x), SWIM_SPEED)
			
			if Input.is_action_just_pressed("jump"):
				jump(JUMP_VELOCITY * 0.7)
			
			if not swimming:
				state = STATE.MOVE
			
			move_and_slide()
		STATE.FLY:
			anim.play("flying")
			if x_input != 0:
				rig.scale.y = update_flip()
				
			rig.rotation = velocity.angle() + PI
			rig.rotation_degrees -= 300*delta*x_input
			velocity = Vector2.LEFT.rotated(rig.rotation) * velocity.length()
			apply_gravity(delta, get_gravity() * 0.6)
			if is_on_floor():
				state = STATE.MOVE
				reset_flip()
			
			if Input.is_action_just_pressed("jump"):
				if climbing:
					state = STATE.CLIMB
				else:
					state = STATE.MOVE
				reset_flip()
			
			apply_friction(delta, 0.2 * Vector2.ONE)
			move_and_slide()

func _on_climbing_body_entered(body: Node2D) -> void:
	climbing = true

func _on_climbing_body_exited(body: Node2D) -> void:
	climbing = false
	
func _on_swim_detector_body_entered(body: Node2D) -> void:
	if not can_swim:
		NotifyMe.show_me("YOU CANNOT SWIM YET!", 1, 1, NotifyMe.DIE)
		respawn()
	swimming = true
	state = STATE.SWIM
	velocity.y = sign(velocity.y) * max(SWIM_SPEED , 0.9 * abs(velocity.y))

func _on_swim_detector_body_exited(body: Node2D) -> void:
	swimming = false
	
func _on_collecting_area_entered(area: Area2D) -> void:
	if area is collectible:
		set_values(area.get_fly(), area.get_climb(), area.get_swim(), area.get_points())
		area.die()
	elif area is flag:
		if area.checkpoint_get(checkpoint):
			checkpoint += 1
			checkpoint_pos = area.global_position
			NotifyMe.show_me("Checkpoint Get!", checkpoint, WIN_CHECKPOINT, CHECKPOINT)
			if checkpoint >= WIN_CHECKPOINT:
				win()

func apply_gravity(delta, amount: Vector2 = get_gravity()) -> void:
	velocity += amount * delta

func jump(amount: = JUMP_VELOCITY) -> void:
	velocity.y = -amount
	
func apply_friction(delta, dir := Vector2.RIGHT) -> void:
	var friction_amount: = FRICTION
	if not is_on_floor(): friction_amount = AIR_FRICTION
	if dir.x > 0:
		velocity.x = move_toward(velocity.x, 0.0, friction_amount * delta * dir.x)
	if dir.y > 0:
		velocity.y = move_toward(velocity.y, 0.0, friction_amount * delta * dir.y)

func update_flip() -> int: #completed
	if velocity.x > 0: 
		return -1
	else:
		return 1

func reset_flip() -> void:
	if state != STATE.FLY:
		rig.scale.y = 1
		rig.scale.x = update_flip()
		rig.rotation_degrees = 0
	else:
		rig.scale.x = 1

func set_values(fly: bool, climb: bool, swim: bool, points: int):
	ui_player.set_fly(fly)
	ui_player.set_climb(climb)
	ui_player.set_swim(swim)
	ui_player.add_points(points)
	can_fly = can_fly || fly
	can_climb = can_climb || climb
	can_swim = can_swim || swim

func respawn():
	global_position = checkpoint_pos
	state = STATE.MOVE
	reset_flip()

func win():
	NotifyMe.show_me("You Win!", checkpoint, WIN_CHECKPOINT, CHECKPOINT)
