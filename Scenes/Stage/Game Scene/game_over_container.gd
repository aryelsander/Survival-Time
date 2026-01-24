class_name GameOverMenu extends VBoxContainer

@onready var total_currency_text: RichTextLabel = $TotalCurrencyText
@onready var retry_button: Button = $RetryButton
@onready var back_to_upgrades_button: Button = $BackToUpgradesButton
@onready var back_to_main_menu_button: Button = $BackToMainMenuButton
@onready var game_scene: GameScene = $"../.."

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button)
	back_to_upgrades_button.pressed.connect(_on_back_to_upgrades_button)
	back_to_main_menu_button.pressed.connect(_on_back_to_main_menu_button)
	

func _on_retry_button() -> void:
	#get_tree().reload_current_scene()
	ChangeSceneManager.reload_scene(get_tree())

func _on_back_to_upgrades_button() -> void:
	
	ChangeSceneManager.change_scene("res://Scenes/Stage/Upgrade Scene/upgrade_scene.tscn")

func _on_back_to_main_menu_button() -> void:
	ChangeSceneManager.change_scene("res://Scenes/Stage/Main Menu/main_menu.tscn")
	
func show_menu(_total_currency : float) -> void:
	total_currency_text.text = "Total: [img widht=64 height=64]uid://d0cad5bhnnlc6[/img]" + str(_total_currency)
	visible = true
