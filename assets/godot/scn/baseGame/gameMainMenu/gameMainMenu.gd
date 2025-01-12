# Responsible for mainmenu. Camera montage, mainmenu buttons, exit buttons.

extends Node2D
#------------------------------------------------------------------------------#
# Montage camera for map.
@onready var _menuCamera: Camera2D = get_node("uiCamera")

# UI Elements animation. Button hover etc not included.
@onready var _uiAnim: AnimationPlayer = get_node("uiLayer/uiMenu/uiAnim")
@onready var _uiAnimMngr: AnimationTree = get_node("uiLayer/uiMenu/uiAnimMngr")

# Main menu buttons.
@onready var _uiStartExplorationBtn: Button = get_node("uiLayer/uiMenu/uiBtnGrp/uiExploStartBtn")
@onready var _uiNewSectGenBtn: Button = get_node("uiLayer/uiMenu/uiBtnGrp/uiNewSectGenBtn")
@onready var _uiLocSectBtn: Button = get_node("uiLayer/uiMenu/uiBtnGrp/uiLocSectBtn")
@onready var _uiExitGameBtn: Button = get_node("uiLayer/uiMenu/uiBtnGrp/uiMenuExit")

@onready var _uiInactivityTimer: Timer = get_node("uiLayer/uiMenu/uiAnim/uiInactivity")

# Locate Sector buttons and inputs.
@onready var _uiSSK: LineEdit = get_node("uiLayer/uiMenu/uiLocSect/uiSSK")

var _menuCamChanged: bool = false
var _uiLocFocused: bool = false
var _uiHidden: bool = false
var _selectArc: bool = false
var _startedOnce: bool = false

#------------------------------------------------------------------------------#
signal _montage

#------------------------------------------------------------------------------#
func _ready() -> void:
	_uiAnimMngr.set_active(true)
	
	# Connects the signals to its respective functions.
	# Most of these are input buttons. 
	_uiStartExplorationBtn.connect("exploreMindscape", Callable(self, "_proceedToMindscape"))
	_uiNewSectGenBtn.connect("discoverMindscape", Callable(self, "_generateNewMindscape"))
	_uiLocSectBtn.connect("locateMindscape", Callable(self, "_locateMindscape"))
	_uiSSK.connect("locatingMindscape", Callable(self, "_locatingMindscape"))
	_uiExitGameBtn.connect("exitGame", Callable(self, "_exitGame"))
	
	# Starts the camera animation and changes the quote.
	_montage.emit()

# Fires when input event happens, every time.
func _input(_event) -> void:
	pass

# Fires when input event happens and no GUI detects it.
# Useful for closing panels by just clicking outside.
func _unhandled_input(_event) -> void:
	if _event is InputEventMouseButton:
		if _uiLocFocused:
			if _selectArc:
				_startArc(0)
			else:
				_locateMindscape(1)
			_uiLocFocused = false
	
	if _event is InputEventMouseMotion:
		if  _event.velocity > Vector2.ZERO and _uiHidden:
			_uiHidden = false
			_uiAnim.play_backwards("uiFadeInactivity")
			lib.editCursorVisibility(true)
		
		elif _event.velocity == Vector2.ZERO and not _uiHidden:
			_uiInactivityTimer.start(25)

#------------------------------------------------------------------------------#
# Tween camera position across random positions in the map.
func _montageGame() -> void:
	if _menuCamera.is_current():
		# Locks the camera to be changed.
		if !_menuCamChanged:
			_menuCamChanged = true
		
		# IMPORTANT CODE: Manages camera animation on main menu.
		var _menuCamTween: Tween = create_tween()
		
		var _menuCamPos: Vector2 = lib.genRandSplitVec2(-lib.sectSize, lib.sectSize)
		var _menuCamDuration: float = lib.genRand(45, 90, "float")
		
		_menuCamTween.tween_property(_menuCamera, "global_position", _menuCamPos, _menuCamDuration).set_ease(Tween.EASE_OUT)
		
		if _menuCamTween:
			await _menuCamTween.finished
		_montage.emit()

# Proceed to sector.
func _proceedToMindscape() -> void:
	# Play the introduction animation on overlay while adding the playthrough.
	if not _startedOnce:
		_uiAnim.play("travelToSector")
		_startedOnce = true
		_selectArc = true
		_uiLocFocused = true
	else:
		_startArc(1)
	
	await _uiAnim.animation_finished
	
	_menuCamChanged = false

# Generate new sector.
func _generateNewMindscape() -> void:
	# Play the loading animation on overlay while generating another sector.
	_uiAnim.play("generateNewSectorFade")
	
	# IMPORTANT CODE: Timer is a must to ensure that the animation overlay will not be late and make the loading visible.
	await get_tree().create_timer(1.1).timeout
	
	# Call a signal to sector manager. To revert textures.
	get_tree().call_group("mindscapeManager", "reloadSpaceSector", "randomized")

# Locate specified sector.
func _locateMindscape(_mode: int = 0) -> void:
	# Play the locate overlay.
	if _mode == 0:
		_uiAnim.play("locateSectorOverlay")
		_uiLocFocused = true
	else: 
		_uiAnim.play_backwards("locateSectorOverlay")

func _startArc(_mode: int = 0) -> void:
	if _mode == 0:
		_uiAnim.play("toMainMenu")
		_selectArc = false
	elif _mode == 1:
		_uiAnim.play_backwards("toMainMenu")
		_selectArc = true
		_uiLocFocused = true

# Locating specified sector.
func _locatingMindscape() -> void:
	_uiLocFocused = false
	_uiAnim.play_backwards("locateSectorOverlay")
	
	# Waiting for the panel to disappear to continue.
	await _uiAnim.animation_finished
	_uiAnim.play("generateNewSectorFade")
	
	# IMPORTANT CODE: Timer is a must to ensure that the animation overlay will not be late and make the loading visible.
	await get_tree().create_timer(1.1).timeout
	
	get_tree().call_group("mindscapeManager", "reloadSpaceSector", "preset")

# Exit Game.
func _exitGame() -> void:
	# Call a signal to sector manager. To clear textures.
	get_tree().call_group("mindscapeManager", "disposeSpaceSector")
	
	# Signal to quit game.
	get_tree().call_group("sceneManager", "quitGame")

# Enable mainmenu process.
func goToMainMenu() -> void:
	# Enable mainmenu.
	lib.gameplay_enabled = false
	for _node in get_children():
		_node.set_process_mode(Node.PROCESS_MODE_INHERIT)
	_menuCamera.set_enabled(true)
	_montage.emit()
	
	# Reset the animation and replay the mainmenu.
	_uiAnim.play("RESET")
	await _uiAnim.animation_finished
	_uiAnim.play("uiMainMenuAnimation")

# Hide UI when inactivity.
func _on_ui_inactivity_timeout() -> void:
	_uiAnim.play("uiFadeInactivity")
	await _uiAnim.animation_finished
	_uiHidden = true
	lib.editCursorVisibility(false)

#------------------------------------------------------------------------------#
# Hide cursor.
func editCursorVisibility(showCursor: bool) -> void:
	lib.editCursorVisibility(showCursor)

#------------------------------------------------------------------------------#
func startArc() -> void:
	# Call a signal to sector manager. To start the arc.
	print("Starting an arc...")
