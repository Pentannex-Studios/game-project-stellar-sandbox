# Gameplay to mainmenu.

extends Button
#------------------------------------------------------------------------------#

@onready var uiToMenuAnimation: AnimationPlayer = get_node("uiToMenuAnimation")
@onready var uiToMenuSFX: AudioStreamPlayer = get_node("uiToMenuSFX")

#------------------------------------------------------------------------------#
# Play hover animation button when mouse entered button.
func _whenMouseEnteredButton() -> void:
	uiToMenuAnimation.play("uiToMenuHovered")
	uiToMenuSFX.play()

# Play hover animation button when mouse exits button.
func _whenMouseExitedButton() -> void:
	uiToMenuAnimation.play_backwards("uiToMenuHovered")

# Emit signal to main menu manager.
func _whenMousePressed() -> void:
	uiToMenuAnimation.play_backwards("uiToMenuHovered")
	
	# Return to mainmenu.
	get_parent().get_parent().get_node("uiAnim").play_backwards("pause")
	get_parent().get_parent().paused = false
	get_tree().call_group("mainMenu", "goToMainMenu")
	
	# FORMAT: Release focus on the button.
	release_focus()
