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

@export var left_arm_raycaster: RayCast3D
@export var left_arm_sight: Sprite3D
var laser_pellet = load("res://Scenes/laser_pellet.tscn")
@export var left_fire_position: Node3D
var laser_fire_rate:float = 0.1
var laser_fire_timer = 0

@export var right_arm_raycaster: RayCast3D
@export var right_arm_sight: Sprite3D
var gauss_pellet = load("res://Scenes/gauss_pellet.tscn")
@export var right_fire_position: Node3D
var gauss_fire_rate:float=1.0
var gauss_fire_timer = 0

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
	
	#_handle_laser_sights(delta)
	laser_fire_timer += delta
	gauss_fire_timer += delta
	
	if(playerNumber == 1):
		firing_left = Input.get_action_strength("fire_left_p1");
		firing_right = Input.get_action_strength("fire_right_p1");
	if(playerNumber == 2):
		firing_left = Input.get_action_strength("fire_left_p2");
		firing_right = Input.get_action_strength("fire_right_p2");
	
	# Firing weapon affects balance based on torso rotation! TODO maybe
	if(firing_left > 0 and laser_fire_timer > laser_fire_rate):
		drift_vector += Vector2(0.4*delta, -0.1*delta)
		var bullet = laser_pellet.instantiate()
		bullet.position = left_fire_position.global_position
		bullet.forward_dir = -left_fire_position.global_transform.basis.x.normalized()
		bullet.owningPlayer = playerNumber
		get_parent().add_child(bullet)
		laser_fire_timer = 0
	else:
		firing_left = 0
		
		
	if(firing_right > 0 and gauss_fire_timer > gauss_fire_rate):
		drift_vector += Vector2(-4.0*delta, -1.0*delta)
		var gauss = gauss_pellet.instantiate()
		gauss.position = right_fire_position.global_position
		gauss.forward_dir = -right_fire_position.global_transform.basis.x.normalized()
		gauss.owningPlayer = playerNumber
		gauss.speed = 6
		gauss.lifetime = 6
		get_parent().add_child(gauss)
		gauss_fire_timer = 0
	else:
		firing_right = 0
	
	_torso_yaw_offset += (firing_left*torso_left_recoil_speed - firing_right*torso_right_recoil_speed) * delta;
	_torso_yaw_offset = clamp(_torso_yaw_offset, -max_torso_yaw, max_torso_yaw)
	_torso.rotation.y = deg_to_rad(_torso_yaw_offset)


#func _handle_laser_sights(delta: float) -> void:
	#var collision = left_arm_raycaster.get_collider()
	#if(collision != null):
		#left_arm_sight.visible = true
		#left_arm_sight.position = left_arm_raycaster.get_collision_point()
	#else:
		#left_arm_sight.visible = false


func _handle_balance(delta: float) ->  void:
	#apply our drift vector for this frame
	balance_level += drift_vector.limit_length(drift_limit_max)
	
	#update position of balance orb UI
	balanceOrbUI.position = balanceOrbHome + balance_level.limit_length(balance_limit_max)
	
	#check if we are falling over
	if(abs(balance_level.distance_to(balanceOrbHome))) > balance_limit_radius:
		balanceOrbUI.modulate = Color.YELLOW
		#wobble
		_body.rotation.x = balance_level.normalized().x * 0.2
		_body.rotation.z = balance_level.normalized().y * 0.2
		
	else:
		balanceOrbUI.modulate = Color.WHITE
		#normal
		_body.rotation.x = 0
		_body.rotation.z = 0
		
	if(abs(balance_level.distance_to(balanceOrbHome))) > balance_limit_max:
		balanceOrbUI.modulate = Color.RED
		#fall over
		_body.rotation.x = 0
		_body.rotation.z = 90

# Did we get shot?
#func _on_body_hit_box_area_entered(area: Area3D) -> void:
	#print("Hit by " + area.name)
	#if(area.owningPlayer != null and area.owningPlayer != playerNumber):
		##drift_vector += Vector2(randf_range(-0.1,0.1), randf_range(-0.1,0.1))
		#drift_vector += (drift_vector.normalized())
		#
		##was it a gauss bullet?
		#if(area.speed == 6):
			#drift_vector += (drift_vector.normalized())

func _take_damage(amount):
	#print("Taking damage")
	if(amount == 10): #laser
		drift_vector += drift_vector.normalized() * 0.01
	if(amount == 6): #gauss
		drift_vector += drift_vector.normalized() * 0.5
