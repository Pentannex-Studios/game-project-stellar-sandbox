extends CanvasLayer

# Hide cursor.
func editCursorVisibility(showCursor: bool) -> void:
	if showCursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(DisplayServer.screen_get_size() / 2)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
