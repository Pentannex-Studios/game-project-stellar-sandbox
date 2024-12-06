# Responsible for changing the games environment based on commands from the loaded arc.
# Direct change code for environment and others are located here.
# Responsible for animations of the mindscape.
# While the mindScapeMngr is responsible for the generation,
# mindscapeHandler is the one who manages the mindscape animations, tweening, etc.

extends Node2D
#------------------------------------------------------------------------------#

# Mindscape textures.
@onready var _mindscape: Node2D = get_parent().get_node("mindscape")
@onready var _msBgTextures: Array[Sprite2D] = [
	_mindscape.get_node("spaceSectorManager/spaceBgGen/spacePllxMngr/spaceBgPllx/spaceBgTex"),
	_mindscape.get_node("spaceSectorManager/spaceBgGen/spacePllxMngr/spaceGPllx/spaceGasTex"),
	_mindscape.get_node("spaceSectorManager/spaceBgGen/spacePllxMngr/spaceG1Pllx/spaceGasTex1"),
	_mindscape.get_node("spaceSectorManager/spaceBgGen/spacePllxMngr/spaceG2Pllx/spaceGasTex2"),
]

@onready var _msPhTexture: Sprite2D = _mindscape.get_node("spaceSectorManager/spacePhenoGen/spacePllxMngr/spacePTPllx/spacePhenoTex")
@onready var _msStars: GPUParticles2D = _mindscape.get_node("spaceSectorManager/spaceBgGen/spacePllxMngr/spaceBgPllx/stars")

#------------------------------------------------------------------------------#
# Animations.

# Set the mindscape's opacity to value.
func mindscapeSetOpacity(value: float, includeStars: bool = false) -> void:
	var _tween: Tween = create_tween()
	for _tex in _msBgTextures:
		_tween.tween_property(_tex, "modulate:a", value, 0.5)
	
	_tween.tween_property(_msPhTexture, "modulate:a", value, 0.5)
	
	if includeStars:
		_tween.tween_property(_msStars, "modulate:a", value, 0.5)

#------------------------------------------------------------------------------#
func startGameArc() -> void:
	if get_child_count() != 0 and get_child_count() < 2:
		if get_child(0).is_in_group("gameArc"):
			print("Initiated game arc.")
			
			get_child(0).startArc()
			mindscapeSetOpacity(0)
		else:
			print("Game arc initiation failed.")
