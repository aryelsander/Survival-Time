class_name UpgradeScene extends Node2D

@export var default_zoom_camera : Vector2
@export var min_zoom_camera : Vector2
@export var max_zoom_camera : Vector2
@onready var camera_2d: Camera2D = $Camera2D
@onready var reset_button: Button = $CanvasLayer/ResetButton
@onready var upgrade_button: Button = $UpgradeButton
var scroll_speed : Vector2 = Vector2(0.1,0.1)
var drag_speed : float = 1
var last_mouse_pos : Vector2
var dragging : bool
var focused_control : Control
func _ready() -> void:
	default_position()
	reset_button.pressed.connect(default_position)
	upgrade_button.grab_focus()
func _process(delta: float) -> void:
	zoom_camera()
	focused_control = get_viewport().gui_get_focus_owner()
	camera_2d.global_position = focused_control.position
		
		
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
