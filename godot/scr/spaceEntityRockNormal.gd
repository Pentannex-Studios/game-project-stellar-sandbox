extends RigidBody2D
#------------------------------------------------------------------------------#
# Nodes.
@onready var _rockTexture: AnimatedSprite2D = get_node("texture")

#------------------------------------------------------------------------------#
# Rock info for saving.
var rockInfo: Dictionary = {
	"rock_scale": _rockTexture.get_scale().x,
	"rock_type": 0,
	"position": get_position(),
	"rotation": get_rotation_degrees()
}

#------------------------------------------------------------------------------#
# Virtual.
func _ready() -> void:
	_pickRockTex()

#------------------------------------------------------------------------------#
# Custom.
# Pick random position from the rock spritesheet.
func _pickRockTex() -> void:
	# Gets a random frame index from the rock textures.
	var _texPosition: int = lib.genRand(1, _rockTexture.sprite_frames.get_frame_count("default") - 1)
	_rockTexture.frame = _texPosition
	
	# Get the texture from the frame.
	var _texture: Texture2D = _rockTexture.sprite_frames.get_frame_texture("default", _texPosition)
	
	# Randomizes the scale.
	_rockTexture.set_scale(lib.genRandVec2(1, 3, "float"))
	
	# Send data to the create polygon function.
	_createPolygon(_texture.get_image())

# Perform collision creation from image and attach it to the polygon.
func _createPolygon(_texture: Image) -> void:
	var _bitmap: BitMap = BitMap.new()
	_bitmap.create_from_image_alpha(_texture)
	
	# Create the polygon.
	var _polys: Array[PackedVector2Array] = _bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, _texture.get_size()), 3)
	for _poly in _polys:
		var _collision = CollisionPolygon2D.new()
		_collision.polygon = _poly
		
		add_child(_collision)
		
		_collision.position -= Vector2(_bitmap.get_size() * (_rockTexture.get_scale().x / 2))
		_collision.scale = Vector2(_rockTexture.get_scale().x, _rockTexture.get_scale().x)
