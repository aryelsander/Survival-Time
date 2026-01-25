extends Control
@onready var label: Label = $Label
@onready var button: Button = $Button

func _ready() -> void:
	label.text = tr("WIN_MESSAGE")
	button.text = tr("BACK")
	button.disabled = true
	var timer = Timer.new()
	get_tree().current_scene.add_child(timer)
	timer.start(3)
	timer.timeout.connect(func(): button.disabled = false)
	button.pressed.connect(func(): get_tree().change_scene_to_file("uid://b38r8med5cvwg"))
