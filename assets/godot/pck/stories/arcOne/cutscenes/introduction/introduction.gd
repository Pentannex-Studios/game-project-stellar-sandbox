extends Node2D

var cutsceneID: String = "main_introduction"

# Hide cursor.
func editCursorVisibility(showCursor: bool) -> void:
	lib.editCursorVisibility(showCursor)

func get_animator() -> AnimationNodeStateMachinePlayback:
	var _animator: AnimationNodeStateMachinePlayback = get_node("cutsceneAnimator").get("parameters/playback")
	return _animator
