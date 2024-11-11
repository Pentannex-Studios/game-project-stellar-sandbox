# Load game arcs and store most important information here that is not common.
# If common, put in lib singleton.
# Save the played arcs and scores in file.
# Probably put here the loading and saving features.

extends Node2D
#------------------------------------------------------------------------------#
# Nodes.
@onready var _spaceGameArc: Node2D = get_node("spaceGameArc")

#------------------------------------------------------------------------------#
# Load game arc loaded from the scene loader and place it.
func loadGameArc(arc: Object) -> void:
	# Clean the game arc from other stuff.
	for _arc in _spaceGameArc.get_children():
		_arc.queue_free()
	
	# Add the game arc.
	_spaceGameArc.add_child(arc.instantiate(), true)
