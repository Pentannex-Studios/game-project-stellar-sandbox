

extends Node2D
#------------------------------------------------------------------------------#
# Parallax strength for each layer
const fgParallaxStrength = 0.01
const bgParallaxStrength = 0.002

#------------------------------------------------------------------------------#
# Nodes for each layer
@export var bg: Node2D
@export var fg: Node2D

#------------------------------------------------------------------------------#
# Track the original positions of each layer
var fgOrigin = Vector2.ZERO
var bgOrigin = Vector2.ZERO

#------------------------------------------------------------------------------#
func _ready() -> void:
	# Store the original positions to offset them correctly later
	if fg != null:
		fgOrigin = fg.get_position()
	if bg != null:
		bgOrigin = bg.get_position()

#------------------------------------------------------------------------------#
func _physics_process(_delta: float) -> void:
	applyMouseParallax()

#------------------------------------------------------------------------------#
func applyMouseParallax() -> void:
	# Calculate mouse position relative to the center of the screen
	var mouseOffset = (get_global_mouse_position() - Vector2(get_viewport().get_size()) / 2) / Vector2(get_viewport().get_size())
	
	# Apply parallax based on each layer's strength and direction
	if fg != null:
		fg.set_position(fgOrigin + mouseOffset * fgParallaxStrength * Vector2(get_viewport().size))
	
	if bg != null:
		bg.set_position(bgOrigin + mouseOffset * bgParallaxStrength * Vector2(get_viewport().size))
