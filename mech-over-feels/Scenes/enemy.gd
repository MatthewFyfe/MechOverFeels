extends RigidBody3D

@export var move_speed: float = 2.5

enum enemyState {IDLE, PATROL, ATTACK}
var currentState = enemyState.PATROL
var goalLocation:Vector3 = position
var distanceThreshold = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match currentState:
		enemyState.IDLE:
			goalLocation = position
		enemyState.PATROL:
			#move randomly to nearby place, or select a new target if we are there
			if(_at_destination()):
				_select_new_goal()
			else:
				_move_towards_goal()
		enemyState.ATTACK:
			#move towards player and shoot at them
				_attack_player()

func _at_destination() -> bool:
	var distance:Vector3 = position - goalLocation
	if(abs(distance.x) < distanceThreshold and abs(distance.z) < distanceThreshold):
		return true
	return false

func _move_towards_goal() -> void:
	var direction = (position + goalLocation).normalized()
	apply_central_force(direction * move_speed)

func _select_new_goal() -> void:
	var randX = randi_range(-5, 5)
	var randZ = randi_range(-5, 5)
	goalLocation = Vector3(position.x + randX, position.y, position.z + randZ);

func _attack_player() -> void:
	pass
