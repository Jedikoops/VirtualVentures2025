extends Node

const POPUP_UI = preload("res://popup_ui.tscn")
const FLOWER_COMPLETE = preload("res://flower_complete.png")
const DIE = preload("res://person.png")

func show_me(info:String = "Title", num:= 1, denom:= 1, sprite:= FLOWER_COMPLETE):
	var temp = POPUP_UI.instantiate()
	get_tree().root.add_child(temp)
	temp.setInfo(info, num, denom, sprite)
