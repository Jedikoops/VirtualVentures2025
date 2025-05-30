extends CharacterBody2D

@export var DAMAGE = 99.99

@export var SPEED = 50.0
@onready var movingRight: bool = true

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()
	#override the stabzone's damage value
	$StabZone.DAMAGE = DAMAGE
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

func _on_death_area_entered(area: Area2D) -> void:
	print(area.get_parent().get_class())
	if area.get_parent().get_class() != "CharacterBody2D":
		return
	if !area.get_parent().is_on_floor():
		area.get_parent().velocity.y *= -1.0
		queue_free()
	pass # Replace with function body.
