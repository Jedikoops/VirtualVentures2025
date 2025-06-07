class_name flag extends Area2D

@export var checkpoint = 1
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sounds: sound_creator = $sound_creator

func checkpoint_get(value):
	if checkpoint == value + 1: #important to add one
		print("you got the checkpoint")
		anim.play("rise")
		sounds.play_sound(0)
		return true
	elif checkpoint <= value:
		print("you already got this one")
		return false
	else:
		print("oops! you skipped a checkpoint")
		return false


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "rise":
		anim.play("wave")
