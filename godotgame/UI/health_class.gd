class_name health_component extends Timer

@export var parent: Node
var can_take_dmg: bool = true
@export var MAX_HEALTH = 100.0
var health

func _ready() -> void:
	health = MAX_HEALTH
	if parent == null:
		parent = get_parent()


func take_damage(amount := 1.0):
	health -= amount
	get_parent().velocity = Vector2.UP * 200
	start()
	can_take_dmg = false
	if health <= 0.0:
		health = MAX_HEALTH
		NotifyMe.show_me("YOU DIED TO HAZARDS!", 1, 1, NotifyMe.DIE)
		get_parent().respawn()



func _on_hurtbody_entered(body: Node2D) -> void:
	print("ahh")
	if not can_take_dmg:
		pass
	else:
		take_damage()

func _on_hurtbox_entered(area: Area2D) -> void:
	if not can_take_dmg:
		pass
	else:
		if area.has_method("getDamage"):
			take_damage(area.getDamage())
		else:
			take_damage()

func get_health():
	return health
	
func get_max_health():
	return MAX_HEALTH

func _on_timeout() -> void:
	can_take_dmg = true
