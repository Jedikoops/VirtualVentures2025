class_name health_component extends Node

@export var parent: Node
@export var MAX_HEALTH = 5
var health
#signal die

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	if parent == null:
		parent = get_parent()

func take_damage(amount := 1):
	health -= amount
	if health <=0:
		#die.emit()
		parent.queue_free()
	#print("yeouch")

func _on_hurtbox_entered(area: Area2D) -> void:
	take_damage()
	#connect this to an area2D that is only on layer
