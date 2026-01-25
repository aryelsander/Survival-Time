class_name UpgradeScene extends Node2D
signal on_buy_upgrade

@export var default_zoom_camera : Vector2
@export var min_zoom_camera : Vector2
@export var max_zoom_camera : Vector2
@onready var camera_2d: Camera2D = $Camera2D
@export var initial_button: UpgradeButton
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var enter_game_text: RichTextLabel = $CanvasLayer/EnterGameText
@onready var buy_upgrade_text: RichTextLabel = $CanvasLayer/BuyUpgradeText
@onready var currency_text: RichTextLabel = $CanvasLayer/CurrencyText
@export var upgrade_scene_music : AudioStream
var scroll_speed : Vector2 = Vector2(0.1,0.1)
var drag_speed : float = 1
var last_mouse_pos : Vector2
var dragging : bool
var focused_control : Control
var is_shaking : bool = false
var hold_complete : float = 0.75
var current_hold : float = 0
func _ready() -> void:
	initial_button.button.grab_focus()
	update_ui()
	ControllerManager.change_controls.connect(update_ui)
	if (AudioManager.music_player.playing and AudioManager.music_player.stream != upgrade_scene_music) or not AudioManager.music_player.playing:
		AudioManager.play_music(upgrade_scene_music)

func hack_add_currency() -> void:
	GameManager.save_data.add_currency(1000)
	update_ui()
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("button_3"):
		shake_camera()
		current_hold = clamp(current_hold + _delta,0,hold_complete)
		if current_hold == hold_complete:
			ChangeSceneManager.change_scene("res://Scenes/Stage/Game Scene/game_scene.tscn")
	
		
	if Input.is_action_just_released("button_3"):
		current_hold = 0
		is_shaking = false
		camera_2d.rotation = 0
	if is_shaking: return
	focused_control = get_viewport().gui_get_focus_owner()
	if focused_control:
		var get_upgrade_button : Control = focused_control.find_parent("PanelContainer").get_parent() as UpgradeButton
		camera_2d.global_position = get_upgrade_button.global_position + get_upgrade_button.size / 2
		get_upgrade_button.show_description()
		

func update_ui() -> void:
	currency_text.text = "[img widht=64 height=64]uid://d0cad5bhnnlc6[/img]" + str(GameManager.save_data.currency)
	enter_game_text.text = ControllerManager.set_button_configuration(tr("ENTER_GAME_TEXT"),96)
	buy_upgrade_text.text = ControllerManager.set_button_configuration(tr("BUY_UPGRADE_TEXT"),96)
func shake_camera() -> void:
	camera_2d.rotate(0.1)
	is_shaking = true
func zoom_camera() -> void:
	if Input.is_action_just_released("zoom_in"):
		camera_2d.zoom = clamp(camera_2d.zoom + scroll_speed,min_zoom_camera,max_zoom_camera)
	if Input.is_action_just_released("zoom_out"):
		camera_2d.zoom = clamp(camera_2d.zoom - scroll_speed,min_zoom_camera,max_zoom_camera)
		
func default_position() -> void:
	camera_2d.zoom = default_zoom_camera
	camera_2d.position = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_pos = event.position
			else:
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		var delta : Vector2 = event.position - last_mouse_pos
		camera_2d.position -= (delta * drag_speed)
		last_mouse_pos = event.position
