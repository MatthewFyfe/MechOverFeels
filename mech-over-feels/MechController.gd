extends CharacterBody3D

@export var move_speed: float = 5.0
@export var turn_speed: float = 60.0        # degrees/sec
@export var torso_turn_speed: float = 90.0  # degrees/sec
@export var torso_left_recoil_speed: float = 45.0 #degrees/sec
@export var torso_right_recoil_speed: float = 180.0 #degrees/sec
@export var max_torso_yaw: float = 45.0     # degrees from body center

@export var body_path: NodePath
@export var torso_path: NodePath

var _body: Node3D
var _torso: Node3D
var _torso_yaw_offset: float = 0.0  # relative to body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_body = get_node(body_path)
	_torso = get_node(torso_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	_handle_movement(delta)
	_handle_torso_rotation(delta)
	_handle_weapons(delta)
	
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8
	
func _handle_movement(delta: float) -> void:
	var forward := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var turn := Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")

	# Rotate body (tank-style)
	_body.rotate_y(deg_to_rad(-turn * turn_speed * delta))

	# Move in body's forward direction
	var forward_dir := -_body.global_transform.basis.x
	velocity = forward_dir * (forward * move_speed)
	_apply_gravity(delta)
	move_and_slide()

func _handle_torso_rotation(delta: float) -> void:
	# Mouse/keys control torso yaw
	var aim_input := Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	_torso_yaw_offset += -aim_input * torso_turn_speed * delta

	# Clamp torso yaw relative to body
	_torso_yaw_offset = clamp(_torso_yaw_offset, -max_torso_yaw, max_torso_yaw)

	# Apply rotation (relative to body)
	_torso.rotation.y = deg_to_rad(_torso_yaw_offset)
	
func _handle_weapons(delta: float) -> void:	
	var firing_left := Input.get_action_strength("fire_left");
	var firing_right := Input.get_action_strength("fire_right");
	
	_torso_yaw_offset += (firing_left*torso_left_recoil_speed - firing_right*torso_right_recoil_speed) * delta;
	_torso_yaw_offset = clamp(_torso_yaw_offset, -max_torso_yaw, max_torso_yaw)
	_torso.rotation.y = deg_to_rad(_torso_yaw_offset)
