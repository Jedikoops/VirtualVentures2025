class_name collectible extends Area2D
@onready var sound: sound_creator = $Sound
@export var fly: bool = false
@export var swim: bool = false
@export var climb: bool = false
@export var points: int = 5
@onready var sprite: Sprite2D = $Sprite2D
var sound_index = 0
# Called when the node enters the scene tree for the first time.
const CLIMB = preload("res://claw.png")
const SWIM = preload("res://fish.png")
const FLY = preload("res://wing.png")
const COIN = preload("res://arrow.png")
func _ready() -> void:
	if fly:
		#anim.play("fly")
		sprite.texture = FLY
		sound_index = 0
	elif swim:
		sprite.texture = SWIM
		sound_index = 1
	elif climb:
		sprite.texture = CLIMB
		sound_index = 2
	else:
		sprite.texture = COIN
		sound_index = 3
	
func die():
	NotifyMe.show_me("Item Get!", 1,1, sprite.texture)
	sound.play_sound(sound_index)
	queue_free()

func get_climb():
	return climb
func get_swim():
	return swim
func get_fly():
	return fly
func get_points():
	return points
