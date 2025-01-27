# Responsible for changing the games environment based on commands from the loaded arc.
# Direct change code for environment and others are located here.
# Responsible for animations of the mindscape.
# While the mindScapeMngr is responsible for the generation,
# mindscapeHandler is the one who manages the mindscape animations, tweening, etc.

extends Node2D
#------------------------------------------------------------------------------#

# Mindscape textures.
@onready var _mindscape: Node2D = get_parent().get_node("mindscape/spaceSectorManager")

#------------------------------------------------------------------------------#
# Animations.



#------------------------------------------------------------------------------#
# Load game arc loaded from the scene loader and place it.
func prepareArc() -> void:
	if lib.available_arcs:
		pass
	else:
		print("No arcs available. Maybe the arc folders are corrupted...")
