extends Node3D
class_name TTS_Test

@export var scoreLimit = 3
@export var victoryLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Pick a voice. Here, we arbitrarily pick the first English voice.
	var voices = DisplayServer.tts_get_voices_for_language("en")
	var voice_id = voices[1]
	
	DisplayServer.tts_speak("Reactor, online.", voice_id)
	DisplayServer.tts_speak("Sensors, online.", voice_id)
	DisplayServer.tts_speak("Weapons, online.", voice_id)
	DisplayServer.tts_speak("All systems nominal.", voice_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reset(score1, score2) -> void:
	print("reset")
	await get_tree().create_timer(2.0).timeout # Waits for X seconds
	get_tree().paused = false
	
	if(score1 >= scoreLimit):
		victoryLabel.visible = true
		victoryLabel.text = "BLUE WINS!"
		victoryLabel.add_theme_color_override("font_color", Color.SKY_BLUE)
		await get_tree().create_timer(2.0).timeout # Waits for X seconds
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	if(score2 >= scoreLimit):
		victoryLabel.visible = true
		victoryLabel.text = "RED WINS!"
		victoryLabel.add_theme_color_override("font_color", Color.DEEP_PINK)
		await get_tree().create_timer(2.0).timeout # Waits for X seconds
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
