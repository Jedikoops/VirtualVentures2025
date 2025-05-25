extends Control

var next_scene = preload("res://Levels/MainGame.tscn")

func _my_level_was_completed():
	get_tree().change_scene_to_packed(next_scene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)


func _on_animals_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
