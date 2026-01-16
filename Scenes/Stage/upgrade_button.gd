class_name UpgradeButton extends Button

@export var upgrade_button_data : UpgradeButtonData
@onready var description_label: RichTextLabel = $DescriptionLabel

@export_multiline var description_text : String
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_entered.connect(show_description)
	focus_exited.connect(hide_description)
	GameManager.change_language.connect(update_ui)
	update_ui()
	pass

func update_ui() -> void:
	print("Antes de Setar: " + str(description_label.size.y))
	description_label.text = wrap_text_by_words(tr(description_text),upgrade_button_data.max_words_per_line)
	description_label.global_position.y += -description_label.size.y - upgrade_button_data.offset_y
	description_label.global_position.x += description_label.size.x / 2 + (size.x / 2)
	
	print("Depois de Setar: " + str(description_label.size.y))
	print(description_label.text)
func show_description() -> void:
	description_label.visible = true
	
func hide_description() -> void:
	description_label.visible = false	

func _on_mouse_entered() -> void:
	show_description()	
func _on_mouse_exited() -> void:
	if has_focus(): return
	hide_description()

func wrap_text_by_words(text: String, max_chars_per_line: int) -> String:
	var words := text.split(" ", false)
	var lines: Array[String] = []
	var current_line := ""

	for word in words:
		var space =   "" if current_line.is_empty() else " "
		var test_line : String = current_line + space + word

		if test_line.length() <= max_chars_per_line:
			current_line = test_line
		else:
			lines.append(current_line)
			current_line = word

	if not current_line.is_empty():
		lines.append(current_line)

	return "\n".join(lines)
