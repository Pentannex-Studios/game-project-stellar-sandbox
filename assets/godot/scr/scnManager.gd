# Responsible for loading the scenes for the main game.
# 2 Main scenes are located.
# -> Game Proper (Main game, space background and stuff, no arc loaded)
# -> Main menu Proper (Loading arcs, game loop from main menu to game to exit)

extends Node
#------------------------------------------------------------------------------#
# Scene paths here.
var _gameProperPath: String = "res://assets/godot/scn/baseGame/gameProper/gameProper.tscn"
var _uiMenuPath: String = "res://assets/godot/scn/baseGame/gameMainMenu/gameMainMenu.tscn"

#------------------------------------------------------------------------------#
# Arc paths here.
var _arcPaths: Array[String] = [
	"res://assets/godot/pck/stories/arcOne/arcManager/arcOneManager.tscn"
]

#------------------------------------------------------------------------------#
func _ready() -> void:
	# IGNORE: Debug
	print("Initiated PseudoTree ", self, " Initiating scene loading.")
	
	# Load mainmenu and game proper to be added to scene.
	_checkScnRes(_loadPckdScn(_uiMenuPath))
	_checkScnRes(_loadPckdScn(_gameProperPath))
	
	# Load random game arc.
	await get_tree().create_timer(2).timeout
	_arcPaths.shuffle()
	_checkGameArcRes(_loadPckdScn(_arcPaths[0]))

#------------------------------------------------------------------------------#
# Check resource first then add to pseudotree. Print error if null.
func _checkScnRes(_object: Resource) -> void:
	if _object != null:
		# IGNORE: Debug
		print("Adding object ", _object, " as a child of PseudoTree ", self)
		call_deferred("add_child", _object.instantiate())
		# IGNORE: Debug
		print("Adding object ", _object, " is successful.")
		print("#------------------------------------------------------------------------------#")
	
	else:
		# IGNORE: Debug
		print("Resource null. Loading failed.")
		print("#------------------------------------------------------------------------------#")

# Check resource then add to the game as the arc.
func _checkGameArcRes(_object: Resource) -> void:
	if _object != null:
		# IGNORE: Debug
		print("Adding object ", _object, " as a the game arc ", self)
		for _scn in get_children():
			if _scn.get_name() == "spaceGameProper":
				_scn.call_deferred("loadGameArc", _object)
				
				# IGNORE: Debug
				print("Adding object ", _object, " is successful.")
				print("#------------------------------------------------------------------------------#")
	
	else:
		# IGNORE: Debug
		print("Resource null. Loading failed.")
		print("#------------------------------------------------------------------------------#")

# Resource loader.
func _loadPckdScn(_scnPath: String) -> Resource:
	# Progress bar in array to track loading progress.
	var _scnProgress: Array[float] = []
	
	# Limiter to stop loader on spamming a lot of 0 on loading.
	var _scnCountPointer: float = -1
	var _scnStatus: int = 1
	var _scnOutput: Resource
	
	# IGNORE: Debug
	print("\nInitiating loading scene via string path: ", _scnPath)
	
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
