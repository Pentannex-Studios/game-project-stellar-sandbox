extends CharacterBody2D
#------------------------------------------------------------------------------#
# Movement.
const SPEED: float = 175.0
const DECELERATION: float = 15.0
var _vel: Vector2 = Vector2.ZERO 
var _rot: float = 0

#------------------------------------------------------------------------------#

func _physics_process(_delta: float) -> void:
	_manageMovement(_delta)

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
	
	rotation_degrees = lerp_angle(rotation_degrees, rotation_degrees + (_rot * 4), 2)
	
	move_and_slide()
