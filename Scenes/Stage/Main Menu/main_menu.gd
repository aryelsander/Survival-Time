class_name MainMenu extends Control
@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var exit_button: Button = $VBoxContainer/ExitButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var options_menu: OptionsMenu = $"../OptionsMenu"
@onready var confirmation_dialog: ConfirmationDialog = $"../ConfirmationDialog"
@export var music: AudioStream
func _ready() -> void:
	initialize()
	GameManager.change_language.connect(update_ui)
	call_deferred("update_ui")
	call_deferred("set_back_button")
	confirmation_dialog.go_back_requested.connect(close_dialog)
	confirmation_dialog.canceled.connect(close_dialog)
	confirmation_dialog.confirmed.connect(confirm_dialog)
	AudioManager.play_music(music)

func confirm_dialog() -> void:
	GameManager.delete_save_game_data()
	GameManager.get_save_game_data()
	ChangeSceneManager.change_scene.call_deferred("uid://cvgp48j1c7btm")
func close_dialog() -> void:
	confirmation_dialog.hide()
	
func set_back_button() -> void:
	options_menu.back_button.pressed.connect(get_focus)
		

func get_focus() -> void:
	settings_button.grab_focus()

func initialize() -> void:
	new_game_button.grab_focus()
	new_game_button.pressed.connect(_on_start_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_quit_pressed)

func update_ui() -> void:
	new_game_button.text = tr("NEW_GAME")
	continue_button.text = tr("CONTINUE")
	settings_button.text = tr("SETTINGS")
	exit_button.text = tr("EXIT")
	
func _on_start_pressed() -> void:
	confirmation_dialog.cancel_button_text = tr("BACK")
	confirmation_dialog.ok_button_text = tr("CONTINUE")
	confirmation_dialog.title = tr("TITLE_CONFIRMATION_DIALOG")
	confirmation_dialog.dialog_text = tr("TEXT_CONFIRMATION_DIALOG")
	confirmation_dialog.show()
	#GameManager.r
	#get_tree().change_scene_to_file("uid://cvgp48j1c7btm")
	pass
func _on_continue_pressed() -> void:
	ChangeSceneManager.change_scene("uid://cvgp48j1c7btm")

func _on_options_pressed() -> void:
	options_menu.visible = true
	options_menu.option_button.grab_focus()
	pass
func _on_quit_pressed() -> void:
	get_tree().quit()
	pass
