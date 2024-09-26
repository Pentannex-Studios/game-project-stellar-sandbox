#------------------------------------------------------------------------------#
# PENTANNEX STUDIOS ---------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
# PentaCODEXX LIBRARY -------------------------------------------------------- #
# VERSION 0.2 ---------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
# PROJECT K ------------------------------------------------------------------ #
# VERSION ALPHA -------------------------------------------------------------- #
#------------------------------------------------------------------------------#

# Comments // The comments describes the code BELOW it. Not above it.
# Comments // Multi-Line isn't supported yet :>

# Naming // Variables starts first with what they are for.
# Naming // If they are for UI, name it ui... Example: uiQuotes
# Naming // If the word count for the original word maxed at 12, make it short.

# Subroutines // Don't use the word "initiate", "start"... Especially when startLoading,
# Subroutines // Just use "load", "check"... 
# Subroutines  // For functions, verb must be the first word. It must whole.

# Signals // Start with the word "when".

extends Node
#------------------------------------------------------------------------------#
# GLOBAL CONFIGURATION 
#------------------------------------------------------------------------------#

# MAIN MENU
const uiQuotes: PackedStringArray = [
	"Within the cosmic expanse, remember that you are a universe unto yourself, filled with infinite possibilities waiting to be explored.",
	"Like a star illuminating the night sky, let your inner light shine brightly and guide you on your unique journey through life.",
	"In the vastness of space, know that your presence matters.",
	"Just as the moon reflects the sun's radiance, may you reflect the beauty and brilliance within you to inspire others.",
	"When you look up at the stars, remember that you too are made of stardust, carrying the shine within your very being.",
	"Amidst the boundless universe, your dreams and aspirations are the guiding constellations that will lead you to your true destiny.",
	"Like a comet streaking across the night sky, may your life be filled with moments of awe-inspiring wonder.",
	"The cosmic fabric weaves your story into the narrative constellations of the universe, reminding you that your journey is both unique and meaningful.",
	"When you feel lost, remember that you are an explorer of the stars, destined to discover your own path.",
	"Embrace the cosmic symphony within your soul, for you are an instrument of harmony and purpose in the grand orchestra of life.",
	"In the grand cosmos, remember that you are a precious creation, deserving of love, happiness, and the pursuit of your dreams.",
	"Just as stars twinkle in the night sky, let your brilliance shine forth and illuminate the world with the unique gifts you possess.",
	"You are a celestial marvel, a rare gem amidst the vastness of space. Embrace your uniqueness and let it guide you to greatness.",
	"Like a comet leaving a dazzling trail, strive to leave your mark on the universe, knowing that your efforts are meaningful and significant.",
	"Within you lies an entire galaxy of untapped potential. Harness the power of your dreams and reach for the stars, for you are capable of extraordinary achievements.",
	"In the cosmic dance of life, remember that you are the lead, choreographing your own steps with purpose, passion, and determination.",
	"You are a cosmic architect, capable of shaping your own destiny. Build a life that aligns with your truest desires and aspirations.",
	"Like the planets in perfect alignment, trust in the divine order of the universe and have faith in your ability to overcome challenges and manifest your highest aspirations.",
	"As you navigate the vast cosmic ocean of possibilities, remember that every decision you make has the power to shape your reality. Choose wisely and strive for excellence.",
	"In the fabric of existence, you are an essential thread woven with care and intention. Embrace your worth and always give your best, for the universe celebrates your every effort."
] 

# GAME
const minSpawnSeed: int = -9223372036854775807
const maxSpawnSeed: int = 9223372036854775807
const sectSize = 1920
const gasColorMinRnge: float = 0.01
const gasColorMaxRnge: float = 1.00
const gasColorAlpha: float = 0.5

const minRocks: int = 5
const maxRocks: int = 75

#------------------------------------------------------------------------------#
# GLOBAL OBJECTS
#------------------------------------------------------------------------------#
var rng: Object = RandomNumberGenerator.new()

#------------------------------------------------------------------------------#
# GLOBAL INITIATION 
#------------------------------------------------------------------------------#
var SSK: String = "[|179645356571623424|ce624280|ee308280|00000000|356cfd80|2|]"

#------------------------------------------------------------------------------#
# GLOBAL GENERATORS 
#------------------------------------------------------------------------------#
# Generating random numbers. 
func genRand(minVal: float, maxVal: float, type: String = "int", inclNegs: bool = false):
	# "minVal" for lowest value.
	# "maxVal" for highest value.
	# "type" for type of datatype; self-explanatory.
		# "randomInt" for random whole number without minimum and maximum values.
		# "randomFloat" for random decimal number without minimum and maximum value. Snapped to hundredths (0.01).
	# "includeNegatives" for including negative numbers in generation.
	rng.randomize()
	var output
	if inclNegs: output = rng.randf_range(minVal, maxVal) * (rng.randi() % 2 * 2 - 1)
	else: output = rng.randf_range(minVal, maxVal)
	match type:
		"int": output = round(output)
		"float": output = snappedf(output, 0.001)
		"randomInt": output = rng.randi()
		"randomfloat": output = snappedf(rng.randf(), 0.01)
	return output

# Generator Vector2 values with same x, y values.
func genRandVec2(minVal: float, maxVal: float, type: String = "int", inclNegs: bool = false) -> Vector2:
	var output: Vector2 = Vector2()
	var result: float
	result = genRand(minVal, maxVal, type, inclNegs)
	output = Vector2(result, result)
	return output

# Generator Vector2 values with different x, y values.
func genRandSplitVec2(minVal: float, maxVal: float, type: String = "int", inclNegs: bool = true) -> Vector2:
	var output: Vector2 = Vector2()
	output.x = genRand(minVal, maxVal, type, inclNegs)
	output.y = genRand(minVal, maxVal, type, inclNegs)
	return output

# Generates Color values with opacity manipulation "opacity". Returns HTML Color
func genRandColor(minVal: float = gasColorMinRnge, maxVal: float = gasColorMaxRnge, opacity: float = gasColorAlpha) -> String:
	var color: Color = Color(
		genRand(minVal, maxVal, "float",  false), 
		genRand(minVal, maxVal, "float", false), 
		genRand(minVal, maxVal, "float",  false),
		opacity
	)
	var colorHtml: String = color.to_html(true)
	return colorHtml

# Generate true or false statements.
func genTrueOrFalse() -> bool:
	var output: bool 
	var result: int = genRand(0, 1, "int")
	
	output = false if result == 0 else true
	
	return output

#------------------------------------------------------------------------------#
# GLOBAL TOOLS 
#------------------------------------------------------------------------------#
# Reparant a child node "child" to another node "newParent".
func reparentNode(child: Node, newParent: Node) -> void:
	var oldParent = child.get_parent()
	oldParent.remove_child(child)
	newParent.add_child(child)

# Take a Screenshot.
func takeScreenShot(vprt: Viewport) -> void:
	if OS.has_feature("standalone"):
		pass
	else:
		var tx: Texture = vprt.get_texture()
		var img: Image = tx.get_data()
		img.flip_y()
		var _save = img.save_png("res://exportSS.png")

#------------------------------------------------------------------------------#
# ARCHIVES 
# DANGER ZONE: Rewrite the code if you will get a snippet from here.
#------------------------------------------------------------------------------#
#var lifeModulates: Array = [Color(1, 1, 1), Color(1, 0.5, 0), Color(1, 0, 0), Color(0, 1, 1), Color(.5, .5, .5), Color(.1, .1, .1), Color(0, 1, 0.5)]
#
#var camera: Node
#var noise: Object = OpenSimplexNoise.new()
#var noiseSpeed: float = 1
#var noiseStrength: float = 10
#var noiseDecay: float = 5
#var noiseTrack: float = 0.0
#var shakeStrength: float
#var amount: float = 1
#var doShake: bool = false
########################################
########### TRAIL MANAGER ##############
########################################
#func trailManager(trail: Node, node: Node, trailLength: int) -> void:
#	var trailPoint: Vector2 = node.global_position
#	trail.global_position = Vector2(0, 0)
#	trail.global_rotation = 0
#	trail.add_point(trailPoint)
#	while trail.get_point_count() > trailLength:
#		trail.remove_point(0)
#
########################################
########### ROCK FRAGMENT FX ###########
########################################
#func rockFragmentFX(position: Vector2, projectile: String, color: Color, scale: float) -> void:
#	if physicsNode:
#		var rFInst: Object = rockFragment.instance()
#		rFInst.self_modulate = color
#		rFInst.global_position = position
#		match projectile:
#			"collision": 
#				amount = 5
#				rFInst.rAmount = 175
#				rFInst.rScale = scale
#			"blaster": 
#				rFInst.rAmount = 50
#				rFInst.rScale = scale
#			"explosion":
#				rFInst.rAmount = 150
#				rFInst.rScale = scale
#				rFInst.scale = Vector2(12, 12)
#				combatTextManager(position, "Critical", Color(1, 1, 1))
#		physicsNode.add_child(rFInst)
#		rFInst = null
#	pass
########################################
######## CIRCLE EXPLOSION FX ###########
########################################
#func circleExplosionFX(position: Vector2, scale: Vector2) -> void:
#	if physicsNode:
#		var cEInst: Object = circleEx.instance()
#		cEInst.scale = scale
#		cEInst.cAmount = 256
#		physicsNode.add_child(cEInst)
#		cEInst.global_position = position
#		cEInst = null
#	pass
#
########################################
########### COMBAT TEXTS FX ############
########################################
#func combatTextManager(position: Vector2, mode: String, color: Color) -> void:
#	if physicsNode:
#		var cTInst: Node = combatText.instance()
#		cTInst.mode = mode
#		cTInst.color = color 
#		physicsNode.call_deferred("add_child", cTInst)
#		cTInst.global_position = position + generateRandomSeparateVector2(96, 128, "int", true)
#	pass
#
########################################
########### CAMERA SHAKE FX ############
########################################
#func screenShakeManager(delta) -> void:
#	if playerNode:
#		camera = playerNode.get_node_or_null("ship/camera")
#		noise.seed = lib.generateRandomNumber(0, 0, "randomInt", false)
#		noise.period = 2
#		if doShake:
#			shakeStrength = noiseStrength * amount * (camera.zoom.x / 2)
#			camera.zoom -= Vector2(0.05, 0.05)
#			doShake = false
#		noiseTrack += delta * noiseSpeed
#		shakeStrength = lerp(shakeStrength, 0, noiseDecay * delta)
#		if camera:
#			camera.offset = Vector2(noise.get_noise_2d(1, noiseTrack) * shakeStrength, noise.get_noise_2d(5, noiseTrack) * shakeStrength)

#func movementCode() -> void:
#	if lib.checkIfDesktopElseMobile():
#		look_at(get_global_mouse_position())
#		if Input.is_action_pressed("fw"):
#			velocity += transform.x * speed
#			interface.animateBar(false)
#		elif Input.is_action_just_released("fw"):
#			interface.animateBar(true)
#	else:
#		pass

#func checkIfDesktopElseMobile() -> bool:
#	var platform: String
#	platform = OS.get_name()
#	if platform in ["Android", "BlackBerry 10", "iOS"]:
#		return false
#	else:
#		return true
