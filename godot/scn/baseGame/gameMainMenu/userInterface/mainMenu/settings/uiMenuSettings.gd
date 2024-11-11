# Enable the settings

extends Button
#------------------------------------------------------------------------------#

@onready var uiMenuSettingsAnimation: AnimationPlayer = get_node("uiMenuSettingsAnimation")
@onready var uiMenuSettingsSFX: AudioStreamPlayer = get_node("uiMenuSettingsSFX")

#------------------------------------------------------------------------------#
signal gameSettings

#------------------------------------------------------------------------------#
# Play hover animation button when mouse entered button.
func _whenMouseEnteredButton() -> void:
	uiMenuSettingsAnimation.play("uiMenuSettingsHovered")
	uiMenuSettingsSFX.play()

# Play hover animation button when mouse exits button.
func _whenMouseExitedButton() -> void:
	uiMenuSettingsAnimation.play_backwards("uiMenuSettingsHovered")

# Emit signal to main menu manager.
func _whenMousePressed() -> void:
	uiMenuSettingsAnimation.play_backwards("uiMenuSettingsHovered")
	gameSettings.emit()
	
	# FORMAT: Release focus on the button.
	release_focus()
