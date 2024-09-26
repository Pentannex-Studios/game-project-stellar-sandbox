extends Node2D
#------------------------------------------------------------------------------#
@onready var _spaceObjects: Node2D = get_node("spaceObjects")

#------------------------------------------------------------------------------#
var _assetDirectory: Dictionary = {
	"adam": preload("res://godot/pck/nauts/adam/adam.tscn"),
	"rock": preload("res://godot/pck/rocks/rock.tscn")
}

#------------------------------------------------------------------------------#
var _sectorInfo: Dictionary

# IMPORTANT: Reads the sector and load the assets needed.
func loadThread(sectorInfo: Dictionary) -> void:
	_sectorInfo = sectorInfo
	
	# IGNORE: Debug
	print("\nReading sector information for asset generation...")
	
	# Checks the sector information if its new sector or saved one.
	# To know if it will generate random objects or load from the asset dict
	# from the sector information.
	if sectorInfo.state == "fresh":
		# Generates random objects based on SKK.
		# IGNORE: Debug
		print("Sector state is fresh. Generating random objects based on SSK.")
		
		# Random spawning of basic objects.
		_randomizedSpawn()
	
	elif sectorInfo.state == "restored":
		# Generates objects based on asset dictionary.
		_loadSpawn(sectorInfo.asstDict)
	
	# Spawn player after all of the shenanigans inside with the spawning.
	_spawnPlayer()

#------------------------------------------------------------------------------#
# Custom functions, helpers for generating / loading assets.
# Randomized spawning. The SSK will be the basis on what to spawn in the map.
func _randomizedSpawn() -> void:
	# IGNORE: Debug
	print("Segmenting SSK for procedural spawning.")
	print("\nBasic assets defined.")
	
	# Get the Seed from SSK.
	var _spaceSectSeed: int = abs(int(lib.SSK.get_slice("|", 1)))
	
	# Spawn basic objects.
	_spawnRocks(_spaceSectSeed, _sectorInfo.asstDict.info.rockAmount)

func _loadSpawn(_assetDictionary: Dictionary) -> void:
	# IGNORE: Debug
	print("Loading Asset Dictionary.")
	print("\nAssets defined. Spawning...")

#------------------------------------------------------------------------------#
# Functions to spawn objects.
# Rocks. Spawn random of from a dict.
func _spawnRocks(_spaceSectSeed: int, _overrideValue: int = 0) -> void:
	# IGNORE: Debug
	print("    Spawning space rocks.")
	
	var _rockAmount: int = 0
	# Identify if its random spawning or loaded.
	if _overrideValue == 0:
		# RANDOMIZED SPAWNING.
		# Determine the number of rocks.
		for _num in str(_spaceSectSeed):
			if _num.is_valid_int():
				_rockAmount += int(_num)
				_rockAmount = clampi(_rockAmount, lib.minRocks, lib.maxRocks)
		
		# Spawning of rocks.
		for _rock in range(_rockAmount):
			var _rockInst: Node = _assetDirectory.rock.instantiate()
			_spaceObjects.call_deferred("add_child", _rockInst)
			_rockInst.set_position(lib.genRandSplitVec2(0, lib.sectSize, "float"))
			_rockInst.set_rotation_degrees(lib.genRand(0, 360, "float"))
	
	elif _overrideValue > 0:
		# LOADED SPAWNING.
		_rockAmount = _overrideValue
		
		# Load each rock with the state from the asstDict.
		#for _rock in _sectorInfo.asstDict.data.interactables.rocks:
			#var _rockInst: Node = _assetDirectory.rock.instantiate()
			#_spaceObjects.call_deferred("add_child", _rockInst, true)
			#_rockInst.set_position(_rock.position)
			#_rockInst.set_rotation_degrees(_rock.rotation)
	
	# IGNORE: Debug
	print("        Rock Amount: ", _rockAmount)

# Spawn Player.
func _spawnPlayer() -> void:
	var _nautInst: Node = _assetDirectory.adam.instantiate()
	_spaceObjects.call_deferred("add_child", _nautInst)
	_nautInst.set_position(_sectorInfo.asstDict.data.interactables.adam.position)
	_nautInst.set_rotation_degrees(_sectorInfo.asstDict.data.interactables.adam.rotation)

#------------------------------------------------------------------------------#
func _saveAssets() -> void:
	pass
