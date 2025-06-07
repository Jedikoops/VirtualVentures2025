extends CharacterBody2D

@export var damage = 99.99
@export var speed = 50.0
@onready var movingRight: bool = true
@onready var sounds: sound_creator = $SmartSound

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if movingRight:
		velocity.x = -speed
	else:
		velocity.x = speed
		
	move_and_slide()
	if is_on_wall():
		movingRight = !movingRight

func _on_death_area_entered(area: Area2D) -> void:
	print(area.get_parent().get_class())
	if area.get_parent().get_class() != "CharacterBody2D":
		return
	if !area.get_parent().is_on_floor():
		area.get_parent().velocity.y *= -1.0
		sounds.play_sound()
		queue_free()
	pass # Replace with function body.
