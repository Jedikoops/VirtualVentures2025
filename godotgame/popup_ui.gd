extends CanvasLayer

@onready var title: Label = %PopupTitle
@onready var desc: Label = %PopupDesc
@onready var icon: TextureRect = %Icon

func setInfo(info: String, num, denom, sprite: Texture):
	title.text = info
	desc.text = "(%.0f/%.0f)" % [num, denom]
	icon.texture = sprite

func die():
	queue_free()
