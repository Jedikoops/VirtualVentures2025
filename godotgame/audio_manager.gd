class_name sound_creator extends Node

@export var sound_list: Array[AudioStream]
@export var sound: PackedScene

func play_sound(index:= 0):
	var temp: AudioStreamPlayer2D = sound.instantiate()
	temp.stream = sound_list[index]
	get_tree().root.add_child(temp)
