extends CharacterBody2D

enum STATE {MOVE, CLIMB, HIT, SWIM, FLY, DIG}
@export var state: = STATE.MOVE
#climbing and swimming are a lot like the same exept swimming you look at the 
#direction you are going. so could i use the same code. 
#gliding i want ot be like minecraft elytra
#digging like pepper grinder

const SPEED = 100.0
const CLIMB_SPEED = 80.0
const SWIM_SPEED = 120.0
const JUMP_VELOCITY = 280.0
const GLIDE_SPEED = 30.0

const FRICTION: = 10000
const AIR_FRICTION: = 300

var exhausted = true
var climbing: bool = false
var swimming: bool = false
var gliding: bool = false

@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var rig: Sprite2D = $CharacterRig
@onready var climb_cooldown: Timer = $ClimbCooldown

func _ready() -> void:
	state = STATE.MOVE

func _physics_process(delta: float) -> void:
	
	var x_input = Input.get_axis("move_left", "move_right")
	var y_input = Input.get_axis("move_up", "move_down")
	velocity.y -= _get_tile_force() * delta
	
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
			var input = Vector2(x_input, y_input).normalized()
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
			
			apply_friction(delta, Vector2.ONE)
			if x_input != 0:
				velocity.x = x_input * SWIM_SPEED
				rig.scale.x = update_flip()
			apply_gravity(delta, Vector2.DOWN * 3.00)
			
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
			print(rig.rotation_degrees)
			if is_on_floor():
				state = STATE.MOVE
				reset_flip()
			
			if Input.is_action_just_pressed("jump") and not is_on_floor() and climbing:
				state = STATE.CLIMB
				reset_flip()
			
			apply_friction(delta, 0.2 * Vector2.ONE)
			move_and_slide()
		STATE.DIG:
			pass

func _on_climbing_body_entered(body: Node2D) -> void:
	climbing = true
	print("yup")


func _on_climbing_body_exited(body: Node2D) -> void:
	climbing = false
	exhausted = true
	climb_cooldown.start()
	print("nope")

func _get_tile_force() -> float:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	if not tilemap: 
		return 0
	var cell:= tilemap.local_to_map(position)
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var tile_force: float = data.get_custom_data("tile_force")
		if tile_force > 0:
			swimming = true
			state = STATE.SWIM
			reset_flip()
			print("yeya")
			return tile_force
	
	swimming = false
	return 0


func apply_gravity(delta, amount: Vector2 = get_gravity()) -> void:
	if not is_on_floor():
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
		rig.rotation_degrees = 0
	else:
		rig.scale.x = 1
