extends CharacterBody3D

@export var move_speed: float = 5.0
@export var turn_speed: float = 60.0        # degrees/sec
@export var torso_turn_speed: float = 90.0  # degrees/sec
@export var torso_left_recoil_speed: float = 45.0 #degrees/sec
@export var torso_right_recoil_speed: float = 180.0 #degrees/sec
@export var max_torso_yaw: float = 45.0     # degrees from body center

@export var body_path: NodePath
@export var torso_path: NodePath

@export var playerNumber: int
@export var balanceOrbUI: Sprite2D
var balanceOrbHome: Vector2

var _body: Node3D
var _torso: Node3D
var _torso_yaw_offset: float = 0.0  # relative to body

var balance_level: Vector2 = Vector2(0.0,0.0)
var balance_limit_radius: float = 75.0
var balance_limit_max: float = 128.0
var drift_vector: Vector2 = Vector2(0.0,0.0)
var drift_limit_max: float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_body = get_node(body_path)
	_torso = get_node(torso_path)
	balanceOrbHome = balanceOrbUI.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	_handle_movement(delta)
	_handle_torso_rotation(delta)
	_handle_weapons(delta)
	_handle_balance(delta)
	
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8
	
func _handle_movement(delta: float) -> void:
	var forward;
	var turn;
	
	if(playerNumber == 1):
		forward = Input.get_action_strength("move_forward_p1") - Input.get_action_strength("move_backward_p1")
		turn = Input.get_action_strength("turn_right_p1") - Input.get_action_strength("turn_left_p1")
	if(playerNumber == 2):
		forward = Input.get_action_strength("move_forward_p2") - Input.get_action_strength("move_backward_p2")
		turn = Input.get_action_strength("turn_right_p2") - Input.get_action_strength("turn_left_p2")
	
	# Rotate body (tank-style)
	_body.rotate_y(deg_to_rad(-turn * turn_speed * delta))
	# Adjust balance
	if(turn > 0):
		drift_vector += Vector2(-0.05*delta,0)
	elif(turn < 0):
		drift_vector += Vector2(0.05*delta,0)	

	# Move in body's forward direction
	var forward_dir := -_body.global_transform.basis.x
	velocity = forward_dir * (forward * move_speed)
	# Adjust balance
	if(forward > 0):
		drift_vector += Vector2(0,0.05*delta)
	elif(forward < 0):
		drift_vector += Vector2(0,-0.05*delta)
	
	_apply_gravity(delta)
	move_and_slide()

func _handle_torso_rotation(delta: float) -> void:
	# Mouse/keys control torso yaw
	var aim_input
	if(playerNumber == 1):
		aim_input = Input.get_action_strength("aim_right_p1") - Input.get_action_strength("aim_left_p1")
	if(playerNumber == 2):
		aim_input = Input.get_action_strength("aim_right_p2") - Input.get_action_strength("aim_left_p2")
	
	# Simply rotating the torso does not cause imbalance
	
	_torso_yaw_offset += -aim_input * torso_turn_speed * delta

	# Clamp torso yaw relative to body
	_torso_yaw_offset = clamp(_torso_yaw_offset, -max_torso_yaw, max_torso_yaw)

	# Apply rotation (relative to body)
	_torso.rotation.y = deg_to_rad(_torso_yaw_offset)
	
func _handle_weapons(delta: float) -> void:
	var firing_left
	var firing_right
	
	if(playerNumber == 1):
		firing_left = Input.get_action_strength("fire_left_p1");
		firing_right = Input.get_action_strength("fire_right_p1");
	if(playerNumber == 2):
		firing_left = Input.get_action_strength("fire_left_p2");
		firing_right = Input.get_action_strength("fire_right_p2");
	
	# Firing weapon affects balance based on torso rotation!
	if(firing_left > 0):
		drift_vector += Vector2(0.1*delta, -0.025*delta)
	if(firing_right > 0):
		drift_vector += Vector2(-0.1*delta, -0.025*delta)
	
	_torso_yaw_offset += (firing_left*torso_left_recoil_speed - firing_right*torso_right_recoil_speed) * delta;
	_torso_yaw_offset = clamp(_torso_yaw_offset, -max_torso_yaw, max_torso_yaw)
	_torso.rotation.y = deg_to_rad(_torso_yaw_offset)

func _handle_balance(delta: float) ->  void:
	#apply our drift vector for this frame
	balance_level += drift_vector.limit_length(drift_limit_max)
	
	#update position of balance orb UI
	balanceOrbUI.position = balanceOrbHome + balance_level.limit_length(balance_limit_max)
	
	#check if we are falling over
	if(abs(balance_level.distance_to(balanceOrbHome))) > balance_limit_radius:
		balanceOrbUI.modulate = Color.YELLOW
		#wobble
	else:
		balanceOrbUI.modulate = Color.WHITE
		#normal
		
	if(abs(balance_level.distance_to(balanceOrbHome))) > balance_limit_max:
		balanceOrbUI.modulate = Color.RED
		#fall over
