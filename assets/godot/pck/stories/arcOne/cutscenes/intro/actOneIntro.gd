extends CanvasLayer
#------------------------------------------------------------------------------#
@onready var _animation: AnimationPlayer = get_node("actOne/animation")
@onready var _actOneIntroAssets: Node2D = get_node("actOne")
@onready var _actOneUI: Control = get_node("uiLayer/uiMenu")

#------------------------------------------------------------------------------#
# Hide cursor.
func editCursorVisibility(showCursor: bool) -> void:
	if showCursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(DisplayServer.screen_get_size() / 2)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func playCutscene() -> void:
	_animation.play("animation")

#------------------------------------------------------------------------------#
func _on_visibility_changed() -> void:
	if _actOneIntroAssets and _actOneUI:
		_actOneIntroAssets.set_visible(is_visible())
		_actOneUI.set_visible(is_visible())
