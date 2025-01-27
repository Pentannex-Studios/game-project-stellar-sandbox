# Enable the mindscape code validation mode and go to that mindscape.

extends Button
#------------------------------------------------------------------------------#

@onready var uiMenuCodeValidationAnimation: AnimationPlayer = get_node("uiMenuCodeValidationAnimation")
@onready var uiMenuCodeValidationSFX: AudioStreamPlayer = get_node("uiMenuCodeValidationSFX")

#------------------------------------------------------------------------------#
signal locateMindscape

#------------------------------------------------------------------------------#
# Play hover animation button when mouse entered button.
func _whenMouseEnteredButton() -> void:
	if not disabled:
		uiMenuCodeValidationAnimation.play("uiMenuLocateHovered")
		uiMenuCodeValidationSFX.play()

# Play hover animation button when mouse exits button.
func _whenMouseExitedButton() -> void:
	if not disabled:
		uiMenuCodeValidationAnimation.play_backwards("uiMenuLocateHovered")

# Emit signal to main menu manager.
func _whenMousePressed() -> void:
	uiMenuCodeValidationAnimation.play_backwards("uiMenuLocateHovered")
	locateMindscape.emit()
	
	# FORMAT: Release focus on the button.
	release_focus()
