# Getting the mindscape background codes and validating existing ones.

extends LineEdit
#------------------------------------------------------------------------------#
# Nodes.
@onready var _uiMSKAnimation: AnimationPlayer = get_node("uiMSKAnimation")
@onready var _uiLocMSKBtn: Button = get_node("uiLocMSKBtn")
@onready var _uiLocMSKBtnAnim: AnimationPlayer = get_node("uiLocMSKBtn/uiLocMSKAnim")
@onready var _uiMSKSFX: AudioStreamPlayer = get_node("uiMSKSFX")
@onready var _uiMSKNote: Label = get_node("uiMSKNote")

#------------------------------------------------------------------------------#
# Signal to emit when code is properly found.
signal locatingMindscape

#------------------------------------------------------------------------------#
var _uiMSKFocus: bool = false
var _uiMSKHover: bool = false
var _uiMSKLocMode: bool = true

#------------------------------------------------------------------------------#
func _ready() -> void:
	placeholder_text = lib.MSK

# Emits when the textBox is selected.
func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_uiMSKFocus = true

# Emits when the textBox is deselected.
func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if _uiMSKFocus: 
				_uiMSKFocus = false
				
				_whenMouseExited() 
				release_focus()

#------------------------------------------------------------------------------#
# Checks MSK for validity and then updating it to the library for space generation.
func _checkMSK(MSK: String) -> int:
	var _MSKValidity: Array[int] = [1, 1, 1, 1, 1, 1, 1]
	var _MSKOverallValidity: int
	
	# IGNORE: Debug
	print("\n#------------------------------------------------------------------------------#")
	print("Checking MSK validity.")
	
	# MSK Validation Snippet.
	# Checks first if first and last values are enclosed with brackets '['.
	if MSK != "":
		if MSK[0] == '[' and MSK[MSK.length() - 1] == ']':
			# IGNORE: Debug
			print("    Validated MSK: Both brackets are present.")
			_MSKValidity[0] = 3
			
			# The number 8 counts as 7 (INDEX)
			if MSK.get_slice_count('|') == 8: 
				
				# IGNORE: Debug
				print("    Validated MSK: 7 Delimiters are present.")
				
				_MSKValidity[1] = 3
				
				if MSK.get_slice("|", 6) in ["1", "2"]:
					
					# IGNORE: Debug
					print("    Validated MSK: ", MSK.get_slice("|", 6), " is a valid space phenomena.")
					
					_MSKValidity[2] = 3
					
					for _MSKColor in range(4):
						if MSK.get_slice("|", _MSKColor + 2).is_valid_html_color():
							# IGNORE: Debug
							print("    Validated MSK: Color ", MSK.get_slice("|", _MSKColor + 2), " is a valid color.")
							
							_MSKValidity[_MSKColor + 3] = 3
						
						else:
							# IGNORE: Debug
							print("    Validated MSK with warning: Invalid color code ", MSK.get_slice("|", _MSKColor + 2), ".")    
							
							_MSKValidity[_MSKColor + 3] = 2
				else: 
					# IGNORE: Debug
					print("    Invalidated MSK: Invalid phenomena variant.")   
			else:
				# IGNORE: Debug
				print("    Invalidated MSK: Invalid delimiter count. Must be 7.")   
		else:
			# IGNORE: Debug
			print("    Invalidated MSK: Missing brackets.")  
	
	else: 
		_MSKValidity = [0, 0, 0, 0, 0, 0, 0]
	
	# Visual return to MSK Input.
	if _MSKValidity == [3, 3, 3, 3, 3, 3, 3]:
		_MSKOverallValidity = 3
	
	elif _MSKValidity == [0, 0, 0, 0, 0, 0, 0]:
		_MSKOverallValidity = 0
	
	else:
		if _MSKValidity.has(2):
			_MSKOverallValidity = 2
		elif  _MSKValidity.has(1):
			_MSKOverallValidity = 1
	
	print("MSK validity: ", _MSKValidity)
	return _MSKOverallValidity

#------------------------------------------------------------------------------#
# NOTE: Tinatamad ako magrename ng signals WHAHAHA jk
func whenUiMSKAnimFinished(_anim: String) -> void:
	# FORMAT: Waits for the animation to stop before pausing.
	# FORMAT: This way, the hover anim will not glitch when selected.
	if _uiMSKFocus:
		_uiMSKAnimation.pause()

# Fires when textbox is hovered.
func _whenMouseEntered() -> void:
	_uiMSKHover = true
	if !_uiMSKFocus:
		_uiMSKAnimation.play("uiInputMSKHovered")
		_uiMSKSFX.play()

# Fires when textbox exits hover.
func _whenMouseExited() -> void:
	if !_uiMSKFocus and _uiMSKHover:
		_uiMSKHover = false
		_uiMSKAnimation.play_backwards("uiInputMSKHovered")

func _whenMSKLocBtnMouseEntered():
	if !_uiLocMSKBtn.disabled:
		_uiLocMSKBtnAnim.play("uiInputMSKLocateHovered")
		_uiMSKSFX.play()

func _whenMSKLocBtnMouseExited():
	if !_uiLocMSKBtn.disabled:
		_uiLocMSKBtnAnim.play_backwards("uiInputMSKLocateHovered")

func _whenMSKLocBtnPressed():
	if !_uiMSKLocMode:
		# If there's valid text in MSK Input, this will fire.
		locatingMindscape.emit()
		await _uiMSKAnimation.animation_finished
		_uiMSKAnimation.play_backwards("uiInputMSKHovered")
		text = ""
		
		_whenTextChanged(text)
	
	else:
		# If there's no text in MSK Input, the button will enter copy MSK mode.
		DisplayServer.clipboard_set(lib.MSK)
		_uiLocMSKBtn.text = "Copied!"
		
		await get_tree().create_timer(1).timeout
		
		_uiLocMSKBtn.text = "Get Code"

#------------------------------------------------------------------------------#
# Fires when user inputs text in the textbox.
# IMPORTANT CODE: Check MSK for irregularities. Provide random if user agrees.
func _whenTextChanged(_stringText: String) -> void:
	# Matches UI Color for validity of text.
	match _checkMSK(_stringText):
		# Default, " "
		0: 
			modulate = Color.WHITE
			
			_uiLocMSKBtn.disabled = false
			_uiMSKNote.text = ""
			
			# Changes to copy MSK if no text is placed.
			_uiLocMSKBtn.text = "Get Code"
			_uiMSKLocMode = true
			
		# Invalid MSK
		1: 
			modulate = Color.RED
			
			_uiLocMSKBtn.disabled = true
			_uiMSKNote.text = "Invalid Code. Check for errors."
			
			# Changes to locate MSK if text is placed.
			_uiLocMSKBtn.text = "Proceed"
			_uiMSKLocMode = false
		
		# Valid MSK Format, But presets are error. Will replace them randomly.
		2: 
			modulate = Color.AQUA
			
			_uiLocMSKBtn.disabled = false
			_uiMSKNote.text = "Warning! Corrupted code."
			
			# Changes to locate MSK if text is placed.
			_uiLocMSKBtn.text = "Proceed"
			_uiMSKLocMode = false
		
		# Valid and Accepted MSK Format, no change done.
		3: 
			modulate = Color.GREEN
			
			_uiMSKNote.text = "Valid code. Welcome home."
			
			# Changes to locate MSK if text is placed.
			_uiLocMSKBtn.text = "Proceed"
			_uiMSKLocMode = false
			lib.MSK = _stringText

# Update the placeholder once the sector key has been created.
func updatePlaceholderText() -> void:
	placeholder_text = lib.MSK

# Signal when node properties are changed. Useful for UI when disabling mouse passes.
func whenNodePropChanged():
	if _uiLocMSKBtn:
		if mouse_filter == Control.MOUSE_FILTER_STOP:
			_uiLocMSKBtn.mouse_filter = Control.MOUSE_FILTER_STOP
		elif mouse_filter == Control.MOUSE_FILTER_IGNORE:
			_uiLocMSKBtn.mouse_filter = Control.MOUSE_FILTER_IGNORE
