extends Node3D
class_name TTS_Test

@export var scoreLimit = 3
@export var victoryLabel: Label
@export var main_music: AudioStreamPlayer

var tts_volume = 50
var tts_pitch = 0.8
var tts_speed = 1.2
var voice_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Pick a voice. Here, we arbitrarily pick the first English voice.
	var voices = DisplayServer.tts_get_voices_for_language("en")
	voice_id = voices[1]	
	
	#DisplayServer.tts_speak("Reactor, online.", voice_id, tts_volume, tts_pitch, tts_speed)
	#DisplayServer.tts_speak("Sensors, online.", voice_id, tts_volume, tts_pitch, tts_speed)
	#DisplayServer.tts_speak("Weapons, online.", voice_id, tts_volume, tts_pitch, tts_speed)
	DisplayServer.tts_speak("All systems nominal.", voice_id, tts_volume, tts_pitch, tts_speed)
	DisplayServer.tts_speak("Mekka-Tumble Rumble, GO!", voice_id, tts_volume, tts_pitch, 1.0)
	
	await get_tree().create_timer(4.0).timeout # Waits for X seconds
	main_music.play()


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
		DisplayServer.tts_speak("BLUE WINS!", voice_id, tts_volume, tts_pitch, tts_speed)
		victoryLabel.add_theme_color_override("font_color", Color.SKY_BLUE)
		await get_tree().create_timer(2.0).timeout # Waits for X seconds
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	if(score2 >= scoreLimit):
		victoryLabel.visible = true
		victoryLabel.text = "RED WINS!"
		DisplayServer.tts_speak("RED WINS!", voice_id, tts_volume, tts_pitch, tts_speed)
		victoryLabel.add_theme_color_override("font_color", Color.DEEP_PINK)
		await get_tree().create_timer(2.0).timeout # Waits for X seconds
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
