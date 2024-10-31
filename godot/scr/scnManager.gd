extends Node
#------------------------------------------------------------------------------#
# Scene paths here.
var _gameProperPath: String = "res://godot/pck/gameMindscapeGen/gameProper.tscn"
var _uiMenuPath: String = "res://godot/pck/gameMainMenu/gameMainMenu.tscn"
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
func _ready() -> void:
	# IGNORE: Debug
	print("Initiated PseudoTree ", self, " Initiating scene loading.\n")
	
	# Load mainmenu and game proper to be added to scene.
	_checkScnRes(_loadPckdScn(_uiMenuPath))
	_checkScnRes(_loadPckdScn(_gameProperPath))

#------------------------------------------------------------------------------#
# Check resource first then add to pseudotree. Print error if null.
func _checkScnRes(_object: Resource) -> void:
	if _object != null:
		# IGNORE: Debug
		print("Adding object ", _object, " as a child of PseudoTree ", self)
		call_deferred("add_child", _object.instantiate())
		# IGNORE: Debug
		print("Adding object ", _object, " is successful.")
		print("#------------------------------------------------------------------------------#\n")
	
	else:
		# IGNORE: Debug
		print("Resource null. Loading failed.")
		print("#------------------------------------------------------------------------------#\n")

func _loadPckdScn(_scnPath: String) -> Resource:
	# Progress bar in array to track loading progress.
	var _scnProgress: Array[float] = []
	
	# Limiter to stop loader on spamming a lot of 0 on loading.
	var _scnCountPointer: float = -1
	var _scnStatus: int = 1
	var _scnOutput: Resource
	
	# IGNORE: Debug
	print("Initiating loading scene via string path: ", _scnPath)
	
	# IMPORTANT CODE: Load the scene files via resource loader to facilitate loading on progress bar.
	ResourceLoader.load_threaded_request(_scnPath)
	
	# IGNORE: Debug
	print("Proceeding to load ", _scnPath)
	
	# IMPORTANT CODE: Function 'match' checks for identifying status for visual output.
	while true:
		match _scnStatus:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				_scnStatus = ResourceLoader.load_threaded_get_status(_scnPath, _scnProgress)
				# Prevents repetitive percent spamming.
				var _currProgress: float = snapped(_scnProgress[0] * 100, 0.01)
				# If pointer is not the same as the progress, it saves and print the value.
				if _currProgress != _scnCountPointer:
					# IGNORE: Debug
					print("    Loading ", _scnPath, " Progress: ", _currProgress, "%")
					_scnCountPointer = _currProgress
			
			ResourceLoader.THREAD_LOAD_LOADED:
				# IGNORE: Debug
				print("Loaded ", _scnPath)
				break
			
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				# IGNORE: Debug
				print("Loading ", _scnPath, " has failed. Invalid Resource.")
				_scnOutput = null
				break
	
	_scnOutput =  ResourceLoader.load_threaded_get(_scnPath)
	return _scnOutput

# Quit the game.
func quitGame() -> void:
	get_tree().quit()

#------------------------------------------------------------------------------#
