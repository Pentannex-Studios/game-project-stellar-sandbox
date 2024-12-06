extends CanvasLayer
#------------------------------------------------------------------------------#
@onready var _animation: AnimationPlayer = get_node("actOne/animation")
@onready var _actOneIntroAssets: Node2D = get_node("actOne")
@onready var _actOneUI: Control = get_node("uiLayer/uiMenu")

#------------------------------------------------------------------------------#
func _ready() -> void:
	_actOneIntroAssets.set_visible(false)
	_actOneUI.set_visible(false)

#------------------------------------------------------------------------------#
# Hide cursor.
func editCursorVisibility(showCursor: bool) -> void:
	if showCursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(DisplayServer.screen_get_size() / 2)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func playCutscene() -> void:
	_actOneIntroAssets.set_visible(true)
	_actOneUI.set_visible(true)
	_animation.play("animation")
