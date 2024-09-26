extends Node2D
#------------------------------------------------------------------------------#
# IMPORTANT: Reads the sector and load the assets needed.
func loadThread(sectorInfo: Dictionary) -> void:
	# IGNORE: Debug
	print("\nReading sector information for asset generation...")
	
	# Checks the sector information if its new sector or saved one.
	# To know if it will generate random objects or load from the asset dict
	# from the sector information.
	if sectorInfo.state == "fresh":
		# Generates random objects based on SKK.
		# IGNORE: Debug
		print("Sector state is fresh. Generating random objects based on SSK.")
		
		_randomizedSpawn()
	
	elif sectorInfo.state == "restored":
		# Generates objects based on asset dictionary.
		# It is the "asstDict" in the example below.
		# -------------------------------------------- #
#		spaceInfo = {
#			"ssk": lib.SSK,
#			"state": "fresh",
#			"asstDict": {
#				"background": {
#					
#				},
#				
#				"interactable": {
#					"adam": {
#						"position": Vector2(0,0)
#					}
#				}
#			}
#		}
		# -------------------------------------------- #
		
		pass

#------------------------------------------------------------------------------#
# Custom functions, helpers for generating / loading assets.
# Randomized spawning. The SSK will be the basis on what to spawn in the map.
func _randomizedSpawn() -> void:
	# IGNORE: Debug
	print("Segmenting SSK for procedural spawning.")
	
	# Get the Seed from SSK.
	
