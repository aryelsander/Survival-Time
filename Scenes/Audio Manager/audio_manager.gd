extends Node
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var fx_player: AudioStreamPlayer2D = $FXPlayer

func _ready() -> void:
	initialize()

func initialize() -> void:
	if GameManager.configuration_data:
		change_master_volume(GameManager.configuration_data.master_volume)
	pass
func play_music(music : AudioStream) -> void:
	music_player.stream = music
	music_player.play()

func play_fx(fx: AudioStream,position : Vector2) -> void:
	fx_player.stream = fx
	fx_player.position = position
	fx_player.play()
func change_master_volume(value: float) -> void:
	GameManager.configuration_data.master_volume = value
	AudioServer.set_bus_volume_db(0,convert_to_db(value))
	
func change_music_volume(value: float) -> void:
	GameManager.configuration_data.music_volume = value
	AudioServer.set_bus_volume_db(1,convert_to_db(value))	
	
func change_fx_volume(value : float) -> void:
	GameManager.configuration_data.fx_volume = value
	AudioServer.set_bus_volume_db(2,convert_to_db(value))
	
func convert_to_db(value : float) -> float:
	return remap(value,0.0,100.0,-80.0,0.0)
