class_name UpgradeButton extends Control

@export var upgrade_button_data : UpgradeButtonData
@onready var title_label: RichTextLabel = $PanelContainer/VBoxContainer/HeaderContainer/TitleLabel
@onready var value_label: RichTextLabel = $PanelContainer/VBoxContainer/HeaderContainer/ValueLabel
@onready var description_label: RichTextLabel = $PanelContainer/VBoxContainer/DescriptionContainer/DescriptionLabel
@onready var button: Button = $PanelContainer/VBoxContainer/Button
@onready var header_container: HBoxContainer = $PanelContainer/VBoxContainer/HeaderContainer
@onready var description_container: HBoxContainer = $PanelContainer/VBoxContainer/DescriptionContainer
@onready var quantity_label: RichTextLabel = $PanelContainer/VBoxContainer/HeaderContainer/QuantityLabel
@export var right_button : UpgradeButton
@export var left_button : UpgradeButton
@export var down_button : UpgradeButton
@export var top_button : UpgradeButton

@export_multiline var description_text : String
func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.focus_entered.connect(show_description)
	button.focus_exited.connect(hide_description)
	
	GameManager.change_language.connect(update_ui)
	call_deferred("set_buttons")
	update_ui()
	pass

func set_buttons() -> void:
	if right_button:
		button.focus_neighbor_right = right_button.button.get_path()
	if top_button:
		button.focus_neighbor_top = top_button.button.get_path()
	if left_button:
		button.focus_neighbor_left = left_button.button.get_path()
	if down_button:
		button.focus_neighbor_down = down_button.button.get_path()
	

func update_ui() -> void:
	title_label.text = upgrade_button_data.get_title_id
	description_label.text = upgrade_button_data.get_description
	quantity_label.text = "0/" + str(upgrade_button_data.points_data.upgrade_data.size())
	if GameManager.points < upgrade_button_data.points_data.upgrade_data[0].cost[0].value:
		button.disabled = true
func show_description() -> void:
	header_container.visible = true
	description_container.visible = true
	
func hide_description() -> void:
	header_container.visible = false
	description_container.visible = false
	
func _on_mouse_entered() -> void:
	show_description()	
func _on_mouse_exited() -> void:
	if has_focus(): return
	hide_description()
#
#func wrap_text_by_words(text: String, max_chars_per_line: int) -> String:
	#var words := text.split(" ", false)
	#var lines: Array[String] = []
	#var current_line := ""
#
	#for word in words:
		#var space =   "" if current_line.is_empty() else " "
		#var test_line : String = current_line + space + word
#
		#if test_line.length() <= max_chars_per_line:
			#current_line = test_line
		#else:
			#lines.append(current_line)
			#current_line = word
#
	#if not current_line.is_empty():
		#lines.append(current_line)
#
	#return "\n".join(lines)
