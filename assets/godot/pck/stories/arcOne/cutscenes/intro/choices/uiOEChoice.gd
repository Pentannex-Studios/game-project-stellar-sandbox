# Main menu exit to desktop.

extends Button
#------------------------------------------------------------------------------#

@export var uiBtnAnimation: AnimationPlayer 
@export var uiBtnSFX: AudioStreamPlayer

#------------------------------------------------------------------------------#
signal open_eyes

#------------------------------------------------------------------------------#
# Play hover animation button when mouse entered button.
func _whenMouseEnteredButton() -> void:
	uiBtnAnimation.play("uiMenuExitHovered")
	uiBtnSFX.play()

# Play hover animation button when mouse exits button.
func _whenMouseExitedButton() -> void:
	uiBtnAnimation.play_backwards("uiMenuExitHovered")

# Emit signal to main menu manager.
func _whenMousePressed() -> void:
	uiBtnAnimation.play_backwards("uiMenuExitHovered")
	open_eyes.emit()
	
	# FORMAT: Release focus on the button.
	release_focus()
