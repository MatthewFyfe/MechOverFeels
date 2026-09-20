extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_1v_1_pressed() -> void:
	set_1v1_controls()	
	get_tree().change_scene_to_file("res://Scenes/Debug_Test_Scene.tscn")
	

func _on_button_2v_2_pressed() -> void:
	set_2v2_controls()	
	get_tree().change_scene_to_file("res://Scenes/Debug_Test_Scene.tscn")

func set_1v1_controls() -> void:
	#print(InputMap.get_actions())
	# Adjust P1 controls
	InputMap.action_erase_events("aim_left_p1")	
	var newEvent = InputEventKey.new()
	newEvent.keycode = KEY_Q
	InputMap.action_add_event("aim_left_p1", newEvent)
	
	InputMap.action_erase_events("aim_right_p1")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_E
	InputMap.action_add_event("aim_right_p1", newEvent)
	
	InputMap.action_erase_events("fire_left_p1")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_Z
	InputMap.action_add_event("fire_left_p1", newEvent)
	
	InputMap.action_erase_events("fire_right_p1")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_C
	InputMap.action_add_event("fire_right_p1", newEvent)
	
	# Adjust P2 controls
	InputMap.action_erase_events("aim_left_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_LEFT
	InputMap.action_add_event("aim_left_p2", newEvent)
	
	InputMap.action_erase_events("aim_right_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_RIGHT
	InputMap.action_add_event("aim_right_p2", newEvent)
	
	InputMap.action_erase_events("fire_left_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_UP
	InputMap.action_add_event("fire_left_p2", newEvent)
	
	InputMap.action_erase_events("fire_right_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_DOWN
	InputMap.action_add_event("fire_right_p2", newEvent)	

func set_2v2_controls() -> void:
	# Adjust P1
	InputMap.action_erase_events("aim_left_p1")
	var newEvent = InputEventKey.new()
	newEvent.keycode = KEY_J
	InputMap.action_add_event("aim_left_p1", newEvent)
	
	InputMap.action_erase_events("aim_right_p1")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_L
	InputMap.action_add_event("aim_right_p1", newEvent)
	
	InputMap.action_erase_events("fire_left_p1")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_I
	InputMap.action_add_event("fire_left_p1", newEvent)
	
	InputMap.action_erase_events("fire_right_p1")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_K
	InputMap.action_add_event("fire_right_p1", newEvent)
	
	# Adjust P2
	InputMap.action_erase_events("aim_left_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_LEFT
	InputMap.action_add_event("aim_left_p2", newEvent)
	
	InputMap.action_erase_events("aim_right_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_RIGHT
	InputMap.action_add_event("aim_right_p2", newEvent)
	
	InputMap.action_erase_events("fire_left_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_UP
	InputMap.action_add_event("fire_left_p2", newEvent)
	
	InputMap.action_erase_events("fire_right_p2")
	newEvent = InputEventKey.new()
	newEvent.keycode = KEY_DOWN
	InputMap.action_add_event("fire_right_p2", newEvent)
