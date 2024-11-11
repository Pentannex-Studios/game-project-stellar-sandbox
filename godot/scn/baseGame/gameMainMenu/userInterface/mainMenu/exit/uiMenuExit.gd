# Main menu exit to desktop.

extends Button
#------------------------------------------------------------------------------#

@onready var uiMenuExitAnimation: AnimationPlayer = get_node("uiMenuExitAnimation")
@onready var uiMenuExitSFX: AudioStreamPlayer = get_node("uiMenuExitSFX")

#------------------------------------------------------------------------------#
signal exitGame

#------------------------------------------------------------------------------#
# Play hover animation button when mouse entered button.
func _whenMouseEnteredButton() -> void:
	uiMenuExitAnimation.play("uiMenuExitHovered")
	uiMenuExitSFX.play()

# Play hover animation button when mouse exits button.
func _whenMouseExitedButton() -> void:
	uiMenuExitAnimation.play_backwards("uiMenuExitHovered")

# Emit signal to main menu manager.
func _whenMousePressed() -> void:
	uiMenuExitAnimation.play_backwards("uiMenuExitHovered")
	
	# IGNORE: Debug
	print("\nExiting Game.")
	
	exitGame.emit()
	
	# FORMAT: Release focus on the button.
	release_focus()
