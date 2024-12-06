# The story arc script of protagonist's arc.

extends Node2D
#------------------------------------------------------------------------------#

@onready var cutscenes: Array[Resource] = [
	load("res://assets/godot/pck/stories/arcOne/cutscenes/intro/actOneIntro.tscn")
]

@onready var _cutsceneManager: AnimationTree = get_node("spaceCutsceneManager/cutsceneBlend")
@onready var _cutsceneAnimator: AnimationNodeStateMachinePlayback = _cutsceneManager.get("parameters/playback")

#------------------------------------------------------------------------------#
func startArc() -> void:
	print("Started Game Arc.")
	_cutsceneAnimator.travel("intro")
