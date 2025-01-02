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
func loadGameArc(arc: Object) -> void:
	# Clean the game arc from other stuff.
	for _arc in get_children():
		_arc.queue_free()
	
	# Add the game arc.
	add_child(arc.instantiate(), true)

func startGameArc() -> void:
	if get_child_count() != 0 and get_child_count() < 2:
		if get_child(0).is_in_group("gameArc"):
			# IGNORE: Debug
			print("Initiated game arc.")
			
			
			get_child(0).startArc()
			_mindscape.get_node("spaceBgGen").mindscapeSetOpacity(0, false, true)
			_mindscape.get_node("spacePhenoGen").mindscapeSetOpacity(0, true)
		
		else:
			print("Game arc initiation failed.")
