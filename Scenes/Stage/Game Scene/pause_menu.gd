class_name PauseMenu extends VBoxContainer

@onready var game_paused_text: RichTextLabel = $GamePausedText
@onready var continue_button: Button = $ContinueButton
@onready var settings_button: Button = $SettingsButton
@onready var back_to_upgrade_button: Button = $BackToUpgradeButton
@onready var back_to_main_menu: Button = $BackToMainMenu
@onready var game_scene: GameScene = $"../.."
@onready var options_menu: OptionsMenu = $"../OptionsMenu"

func _ready() -> void:
	update_ui()
	GameManager.change_language.connect(update_ui)
	continue_button.pressed.connect(_on_continue)
	settings_button.pressed.connect(_on_settings)
	back_to_upgrade_button.pressed.connect(_on_back_to_upgrade)	
	back_to_main_menu.pressed.connect(_on_back_main_menu)
	options_menu.close.connect(try)
	call_deferred("configure_back_button")
func try() ->void:
	settings_button.grab_focus()
	visible = true

func configure_back_button() -> void:
	options_menu.back_button.pressed.connect(try)

func _on_continue() -> void:
	game_scene.process_mode = Node.PROCESS_MODE_INHERIT
	visible = false

func _on_settings() -> void:
	options_menu.visible = true
	options_menu.option_button.grab_focus()
	visible = false
	pass

func _on_back_to_upgrade() -> void:
	GameManager.global_time_speed = 1
	ChangeSceneManager.change_scene("res://Scenes/Stage/Upgrade Scene/upgrade_scene.tscn")
	
func _on_back_main_menu() -> void:
	GameManager.global_time_speed = 1
	ChangeSceneManager.change_scene("res://Scenes/Stage/Main Menu/main_menu.tscn")
	
func update_ui() -> void:
	game_paused_text.text = tr("PAUSED")
	continue_button.text = tr("CONTINUE")
	back_to_upgrade_button.text = tr("UPGRADES")
	back_to_main_menu.text = tr("MAIN_MENU")
	settings_button.text = tr("SETTINGS")

func open() -> void:
	continue_button.grab_focus()
	game_scene.process_mode = Node.PROCESS_MODE_DISABLED
	visible = true
