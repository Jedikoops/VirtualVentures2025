extends Control

@onready var a_gallery: HBoxContainer = $HBoxContainer
var h_pos: float = 0
var h_size: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(a_gallery.get_rect())
	h_pos = a_gallery.get_rect().position.x
	h_size = a_gallery.get_rect().size.x
	print(h_pos)
	print(h_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	a_gallery.position.x = h_pos
	


func _on_left_button_down() -> void:
	h_pos+= 5
	print("dfs")

func _on_right_button_down() -> void:
	h_pos-= 5
	print("dfs")


func _on_left_pressed() -> void:
	print("dfs")


func _on_button_pressed() -> void:
	print("dfs")
