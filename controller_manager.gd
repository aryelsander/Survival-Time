extends Node

signal change_controls
var current_control : ControllerData
@export var keyboard_and_mouse_controller_data : ControllerData
@export var xbox_controller_data : ControllerData
@export var playstation_controller_data : ControllerData
@export var generic_controller_data : ControllerData
enum ControllerType {
	KeyboardAndMouse,
	XboxController,
	PlaystationController,
	Generic
}

func _ready() -> void:
	current_control = keyboard_and_mouse_controller_data

func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		if current_control.controller_type != keyboard_and_mouse_controller_data.controller_type:
			print("Alterado para Keyboard And Mouse Controller")
			current_control = keyboard_and_mouse_controller_data
			change_controls.emit()
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		var name := Input.get_joy_name(event.device).to_lower()
		if "xbox" in name or "xinput" in name:
			if current_control.controller_type != xbox_controller_data.controller_type:
				print("Alterado para Xbox Controller")
				current_control = xbox_controller_data
				change_controls.emit()
		elif "playstation" in name or "ps4" in name or "ps5" in name or "dualshock" in name or "dualsense" in name:
			print("Alterado para Playstation Controller")
			
			if current_control.controller_type != playstation_controller_data.controller_type:
				current_control = playstation_controller_data
				change_controls.emit()
		elif "generic" in name:
			print("Genérico, não implementado, utilizando do XBox")
			
			if current_control.controller_type != playstation_controller_data.controller_type:
				current_control =  generic_controller_data
				change_controls.emit()
			
			

func set_button_configuration(text: String,image_size : float) -> String:
	text = text.replace("#button_3#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.button_3.resource_path + "[/img]")
	text = text.replace("#button_2#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.button_2.resource_path + "[/img]")
	text = text.replace("#button_1#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.button_1.resource_path + "[/img]")
	text = text.replace("#up#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.up_directional.resource_path + "[/img]")
	text = text.replace("#down#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.down_directional.resource_path + "[/img]")
	text = text.replace("#left#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.left_directional.resource_path + "[/img]")
	text = text.replace("#right#","[img width="+ str(image_size)+ " height=" + str(image_size) +"]" + current_control.right_directional.resource_path + "[/img]")
	return text	
