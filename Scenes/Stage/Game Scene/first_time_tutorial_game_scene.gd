class_name FirstTimeTutorialGameScene extends TextureRect
@onready var up: RichTextLabel = $Up
@onready var down: RichTextLabel = $Down
@onready var left: RichTextLabel = $Left
@onready var right: RichTextLabel = $RIght
@onready var finish_button: Button = $FinishButton
@onready var game_scene: GameScene = $"../.."

func _ready() -> void:
	update_ui()
	finish_button.pressed.connect(finish_tutorial)
	finish_button.grab_focus()
	ControllerManager.change_controls.connect(update_ui)
func update_ui() -> void:
	up.text = ControllerManager.set_button_configuration("#up#",128)
	down.text = ControllerManager.set_button_configuration("#down#",128)
	left.text = ControllerManager.set_button_configuration("#left#",128)
	right.text = ControllerManager.set_button_configuration("#right#",128)

func open_tutorial() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	
func finish_tutorial() -> void:
	visible = false
	game_scene.process_mode = Node.PROCESS_MODE_INHERIT
	process_mode = Node.PROCESS_MODE_DISABLED
	GameManager.save_data.first_time_in_game = false
