extends Node2D

# Parallax strength for each layer
const cityParallaxStrength = 0.01
const cloudsParallaxStrength = 0.002

# Nodes for each layer
@onready var clouds = get_node("clouds")
@onready var city = get_node("city")

# Track the original positions of each layer
var cityOrigin = Vector2.ZERO
var cloudsOrigin = Vector2.ZERO

func _ready() -> void:
	# Store the original positions to offset them correctly later
	cityOrigin = city.get_position()
	cloudsOrigin = clouds.get_position()

func _physics_process(_delta: float) -> void:
	applyMouseParallax()

func applyMouseParallax() -> void:
	# Calculate mouse position relative to the center of the screen
	var mouseOffset = (get_global_mouse_position() - Vector2(get_viewport().get_size()) / 2) / Vector2(get_viewport().get_size())
	
	# Apply parallax based on each layer's strength and direction
	city.set_position(cityOrigin + mouseOffset * cityParallaxStrength * Vector2(get_viewport().size))
	clouds.set_position(cloudsOrigin + mouseOffset * cloudsParallaxStrength * Vector2(get_viewport().size))
