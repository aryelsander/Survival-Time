extends Node

var global_time_speed = 1
var player : Player
var game_scene : GameScene
var player_bonus : PlayerBonusData
var save_data : GameData
signal change_language

var configuration_data : ConfigurationData 
const CURSOR_TEXTURE = preload("uid://yod0uftfb6qs")
const CONFIGURATION_DATA_PATH := "user://configuration_data.tres"
const SAVE_DATA_PATH := "user://save_dat.res"
func _ready() -> void:
	player_bonus = PlayerBonusData.new()
	configuration_data = get_configuration_data()
	save_data = get_save_game_data()
	Input.set_custom_mouse_cursor(CURSOR_TEXTURE,Input.CURSOR_ARROW,Vector2(0,0))
	if configuration_data.language.is_empty():
		configuration_data.language = get_language_from_system()
		set_language(configuration_data.language)
	else:
		set_language(configuration_data.language)
	change_language.emit()

func get_save_game_data() -> GameData:
	if ResourceLoader.exists(SAVE_DATA_PATH):
		var get_data  : GameData = ResourceLoader.load(SAVE_DATA_PATH) as GameData
		return get_data
	
	var new_data : GameData = GameData.default()
	save_game_data(new_data)
	
	return new_data

func save_game_data(_save_data: GameData) -> void:
	var error : Error = ResourceSaver.save(_save_data,SAVE_DATA_PATH)
	pass

func get_configuration_data() -> ConfigurationData:
	if ResourceLoader.exists(CONFIGURATION_DATA_PATH):
		var get_data  : ConfigurationData = ResourceLoader.load(CONFIGURATION_DATA_PATH) as ConfigurationData
		return get_data
	
	var new_data : ConfigurationData = ConfigurationData.default()
	save_configuration_data(new_data)
	
	return new_data
	

func delete_save_game_data() -> bool:
	if not ResourceLoader.exists(SAVE_DATA_PATH):
		return false

	var dir := DirAccess.open("user://")
	if dir == null:
		return false
	
	
	dir.remove("save_dat.res")
	save_data = GameData.default()
	save_data.currency = 1000000
	return true

func delete_configuration_data() -> bool:
	if not ResourceLoader.exists(CONFIGURATION_DATA_PATH):
		return false

	var dir := DirAccess.open("user://")
	if dir == null:
		return false
	
	
	dir.remove("configuration_data.tres")
	return true

func save_configuration_data(_configuration_data: ConfigurationData) -> void:
	var error : Error = ResourceSaver.save(_configuration_data,CONFIGURATION_DATA_PATH)
	pass
	
func set_language(language: String) -> void:
	if language.begins_with("pt"):
		TranslationServer.set_locale("pt")
		GameManager.configuration_data.language = "pt"
	else:
		TranslationServer.set_locale("en")
		GameManager.configuration_data.language = "en"
	change_language.emit()	
	
func get_language_from_system() -> String:
	return TranslationServer.get_locale()
