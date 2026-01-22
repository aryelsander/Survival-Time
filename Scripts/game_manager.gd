extends Node

var global_time_speed = 1
var player : Player
var game_scene : GameScene
var points : int
signal change_language

var configuration_data : ConfigurationData 
const CURSOR_TEXTURE = preload("uid://yod0uftfb6qs")
const CONFIGURATION_DATA_PATH := "user://configuration_data.tres"
func _ready() -> void:
	configuration_data = get_configuration_data()
	
	print(configuration_data.language)
	Input.set_custom_mouse_cursor(CURSOR_TEXTURE,Input.CURSOR_ARROW,Vector2(0,0))
	if configuration_data.language.is_empty():
		print("Ta vazio")
		configuration_data.language = get_language_from_system()
		set_language(configuration_data.language)
	else:
		set_language(configuration_data.language)
	change_language.emit()
func get_configuration_data() -> ConfigurationData:
	if ResourceLoader.exists(CONFIGURATION_DATA_PATH):
		var get_data  : ConfigurationData = ResourceLoader.load(CONFIGURATION_DATA_PATH) as ConfigurationData
		print("Ja existia, buscou o Configuration Data")
		return get_data
	
	var new_data : ConfigurationData = ConfigurationData.default()
	save_configuration_data(configuration_data)
	print("Criou um novo Configuration Data")
	
	return new_data
	

func delete_configuration_data() -> bool:
	if not ResourceLoader.exists(CONFIGURATION_DATA_PATH):
		print("Não existe arquivo para deletar")
		return false  # nada para deletar

	var dir := DirAccess.open("user://")
	if dir == null:
		return false
	
	
	dir.remove("configuration_data.tres")
	print("Configuration Data Removido com sucesso!")
	return true

func save_configuration_data(_configuration_data : ConfigurationData) -> void:
	var error : Error = ResourceSaver.save(_configuration_data,CONFIGURATION_DATA_PATH)
	if error == 0:
			print("Salvo com sucesso")
	pass
	
func set_language(language: String) -> void:
	if language.begins_with("pt"):
		TranslationServer.set_locale("pt")
		GameManager.configuration_data.language = "pt"
		print("Idioma em Português")
	else:
		TranslationServer.set_locale("en")
		GameManager.configuration_data.language = "en"
		
		print("Idioma em Inglês")
	
	change_language.emit()	
	
func get_language_from_system() -> String:
	return TranslationServer.get_locale()
