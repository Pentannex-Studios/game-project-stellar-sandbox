

extends Node2D
#------------------------------------------------------------------------------#
# Parallax strength for each layer
const l1ParallaxStrength = 0.010
const l2ParallaxStrength = 0.005
const l3ParallaxStrength = 0.0001
const l4ParallaxStrength = 0.00005
const l5ParallaxStrength = 0.000010

#------------------------------------------------------------------------------#
# Nodes for each layer
@export var l5: Node2D
@export var l4: Node2D
@export var l3: Node2D
@export var l2: Node2D
@export var l1: Node2D

#------------------------------------------------------------------------------#
# Track the original positions of each layer
var l1Origin = Vector2.ZERO
var l2Origin = Vector2.ZERO
var l3Origin = Vector2.ZERO
var l4Origin = Vector2.ZERO
var l5Origin = Vector2.ZERO

#------------------------------------------------------------------------------#
func _ready() -> void:
	# Store the original positions to offset them correctly later
	if l1 != null:
		l1Origin = l1.get_position()
	if l2 != null:
		l2Origin = l2.get_position()
	if l3 != null:
		l3Origin = l3.get_position()
	if l4 != null:
		l4Origin = l4.get_position()
	if l5 != null:
		l5Origin = l5.get_position()

#------------------------------------------------------------------------------#
func _physics_process(_delta: float) -> void:
	applyMouseParallax()

#------------------------------------------------------------------------------#
func applyMouseParallax() -> void:
	# Calculate mouse position relative to the center of the screen
	var mouseOffset = (get_global_mouse_position() - Vector2(get_viewport().get_size()) / 2) / Vector2(get_viewport().get_size())
	
	# Apply parallax based on each layer's strength and direction
	if l1 != null:
		l1.set_position(l1Origin + mouseOffset * l1ParallaxStrength * Vector2(get_viewport().size))
	if l2 != null:
		l2.set_position(l2Origin + mouseOffset * l2ParallaxStrength * Vector2(get_viewport().size))
	if l3 != null:
		l3.set_position(l3Origin + mouseOffset * l3ParallaxStrength * Vector2(get_viewport().size))
	if l4 != null:
		l4.set_position(l4Origin + mouseOffset * l4ParallaxStrength * Vector2(get_viewport().size))
	if l5 != null:
		l5.set_position(l5Origin + mouseOffset * l5ParallaxStrength * Vector2(get_viewport().size))
