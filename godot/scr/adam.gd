extends CharacterBody2D
#------------------------------------------------------------------------------#
# Nodes.
@onready var _bones: Skeleton2D = get_node("bones")

@onready var _animMngr: AnimationTree = get_node("state")
@onready var _animMngrState: AnimationNodeStateMachinePlayback = _animMngr.get("parameters/playback")

# Movement.
const SPEED: float = 175.0
const DECELERATION: float = 15.0
var _vel: Vector2 = Vector2.ZERO 
var _rot: float = 0
var _lastScale: float
var _hasMoved: bool = false

#------------------------------------------------------------------------------#
@onready var info: Dictionary = {
	"type": "player",
	"position": get_position(),
	"rotation": get_rotation_degrees()
}

#------------------------------------------------------------------------------#
# Virtual.
func _ready() -> void:
	_animMngr.set_active(true)

func _physics_process(_delta: float) -> void:
	_manageMovement(_delta)
	_manageAnimations(_delta)

#------------------------------------------------------------------------------#
# Custom.
func _manageMovement(_delta: float) -> void:
	_vel = Vector2.ZERO
	
	# Take note of the movement.
	# Movement left to right.
	_vel.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_vel.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Rotate.
	_rot = Input.get_action_strength("right_turn") - Input.get_action_strength("left_turn")
	
	# Calculate target velocity based on input
	var targetVelocity = _vel.normalized() * SPEED
	
	# If there's no input, apply deceleration
	if _vel.length() == 0:
		# Smoothly reduce velocity towards zero
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * _delta)
	else:
		# When there is input, accelerate towards the target velocity
		velocity = velocity.move_toward(targetVelocity, SPEED * _delta)
	
	rotation_degrees = lerp_angle(rotation_degrees, rotation_degrees + (_rot * 4), 0.2)
	
	move_and_slide()

func _manageAnimations(_delta: float) -> void:
	_animFlipping()
	_animStateBasic()

func _animFlipping() -> void:
	# Flip left to right.
	if _vel.x > 0:
		_lastScale = 1
	elif _vel.x < 0:
		_lastScale = -1
	else:
		_lastScale = 1 if _lastScale > 0 else -1
	
	_bones.set_scale(Vector2(_lastScale, 1))

func _animStateBasic() -> void:
	# Movement.
	if _vel != Vector2.ZERO:
		_animMngrState.travel("space_move")
		_hasMoved = true
	
	else:
		if _hasMoved:
			_animMngrState.travel("space_look_around")
			
			_hasMoved = false
	
	# Tilting
	# Rotate the player based on movement direction
	var _weight: float = 0.005
	
	if _vel.length() > 0:
		var _angle: float = _vel.angle()
		var _targetAngle: float
		
		if _vel.x < 0:
			_targetAngle = _angle - deg_to_rad(-100)
		else:
			_targetAngle = _angle + deg_to_rad(80)
		
		rotation = lerp_angle(rotation, _targetAngle, _weight)
	
	elif _vel.length() == 0:
		rotation = lerp_angle(rotation, 0, _weight)
