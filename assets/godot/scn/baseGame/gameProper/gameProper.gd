# Load game arcs and store most important information here that is not common.
# If common, put in lib singleton.
# Save the played arcs and scores in file.
# Probably put here the loading and saving features.

extends Node2D
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
func _ready() -> void:
	# EDITOR only, checks if the root of the game scene is this scene.
	if get_parent() == get_tree().root:
		lib.gameplay_enabled = true

#------------------------------------------------------------------------------#
func loadMindscape() -> void:
	get_node("mindscape/spaceSectorManager").loadSpaceSector()

#------------------------------------------------------------------------------#
