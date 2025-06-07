class_name player_ui extends CanvasLayer

@export var health : health_component
@onready var health_bar: ProgressBar = %Health
@onready var clock_display: Label = %Clock
var clock: float
var points: int
@onready var climb: TextureRect = %Climb
@onready var swim: TextureRect = %Swim
@onready var fly: TextureRect = %Fly
@onready var coins: Label = %Coins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points = 0
	health_bar.value = 100
	clock = 0
	climb.visible = false
	swim.visible = false
	fly.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health != null:
		health_bar.value = (100 * health.get_health())/ health.get_max_health()
	clock += delta
	clock_display.text = "%.0f min %.0f sec" % [floor(clock/60.0), fmod(clock, 60)]
	coins.text = "%.0f" % points

func add_points(value:int = 1):
	points += value
	
func set_climb(value:bool):
	climb.visible = climb.visible || value

func set_swim(value:bool):
	swim.visible = swim.visible || value
	
func set_fly(value:bool):
	fly.visible = fly.visible || value
