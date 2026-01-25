class_name UpgradeButton extends Control

@export var upgrade_scene : UpgradeScene
@export var requirements: Array[RequirementData]
@export var upgrade_button_data : UpgradeButtonData
@export var right_button : UpgradeButton
@export var left_button : UpgradeButton
@export var down_button : UpgradeButton
@export var top_button : UpgradeButton
@onready var panel_container: PanelContainer = %PanelContainer

@onready var title_label: RichTextLabel = $PanelContainer/VBoxContainer/HeaderContainer/TitleLabel
@onready var description_label: RichTextLabel = $PanelContainer/VBoxContainer/DescriptionContainer/DescriptionLabel
@onready var header_container: HBoxContainer = $PanelContainer/VBoxContainer/HeaderContainer
@onready var description_container: HBoxContainer = $PanelContainer/VBoxContainer/DescriptionContainer
@onready var quantity_label: RichTextLabel = $PanelContainer/VBoxContainer/HeaderContainer/QuantityLabel
@onready var button_text: RichTextLabel = $PanelContainer/VBoxContainer/Button/ButtonText
@onready var button: Button = $PanelContainer/VBoxContainer/Button

var upgrade_count : int
var enable_to_buy : bool
var style : StyleBoxFlat
func _ready() -> void:
	style = panel_container.get_theme_stylebox("panel").duplicate()
	panel_container.add_theme_stylebox_override("panel",style)
	
	button_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.focus_entered.connect(show_description)
	button.focus_exited.connect(hide_description)
	button.pressed.connect(buy)
	ControllerManager.change_controls.connect(update_ui)
	GameManager.change_language.connect(update_ui)
	call_deferred("set_buttons")
	GameManager.save_data.increase.connect(update_ui)
	upgrade_button_data.get_upgrade_effect()
	upgrade_scene.on_buy_upgrade.connect(update_post_buy)
	update_ui()
	pass

func update_post_buy() -> void:
	if requirements.is_empty(): return
	update_ui()
func set_buttons() -> void:
	if right_button:
		button.focus_neighbor_right = right_button.button.get_path()
	if top_button:
		button.focus_neighbor_top = top_button.button.get_path()
	if left_button:
		button.focus_neighbor_left = left_button.button.get_path()
	if down_button:
		button.focus_neighbor_bottom = down_button.button.get_path()
	
func check_requirements() -> bool:

	if requirements.is_empty(): 
		return true
	
	for requirement in requirements:
		var require : bool = false
		var id = requirement.upgrade_data.upgrade_id
		for upgrade in GameManager.save_data.upgrade_list:
			#var upgrade_save_data : UpgradeSaveData = GameManager.save_data.upgrade_list[index]
			if upgrade.upgrade_id == id:
				if upgrade.total_upgrade_buyed >= requirement.level_require:
					require = true
					break
		if not require: 
			return false
	
	return true

func update_ui() -> void:
	title_label.text = upgrade_button_data.get_title_id
	description_label.text = upgrade_button_data.get_description
	get_effect_count()	
	quantity_label.text = str(upgrade_count ) + "/" + str(upgrade_button_data.upgrade_effect_data.max_level)

	if upgrade_count < upgrade_button_data.upgrade_effect_data.max_level:
		if enable_to_buy:
			button_text.text = "[img widht=16 height=16]uid://d0cad5bhnnlc6[/img] " + str(upgrade_button_data.upgrade_effect_data.calculate_cost())
		else:
			button_text.text = upgrade_button_data.get_title_id
		var currency : float = upgrade_button_data.upgrade_effect_data.calculate_cost()
		button.disabled = GameManager.save_data.currency < currency or not check_requirements()
	else:
		button.disabled = true
		button_text.text = tr("MAX")

func buy() -> void:
	if not enable_to_buy:
		return
	
	var currency : float = upgrade_button_data.upgrade_effect_data.calculate_cost()
	if GameManager.save_data.currency >= currency:
		GameManager.save_data.currency -= currency
		#add_upgrade()
		GameManager.save_data.increase_upgrade(upgrade_button_data.upgrade_reference_id)
		update_ui()
		upgrade_scene.on_buy_upgrade.emit()
		upgrade_scene.update_ui()

func get_effect_count() -> void:
	for upgrade in GameManager.save_data.upgrade_list:
		if upgrade.upgrade_id == upgrade_button_data.upgrade_reference_id:
			upgrade_count = upgrade.total_upgrade_buyed
			upgrade_button_data.upgrade_effect_data.current_level = upgrade.total_upgrade_buyed
			return
	upgrade_button_data.upgrade_effect_data.current_level = 0
	
	
func show_description() -> void:
	if upgrade_count < upgrade_button_data.upgrade_effect_data.max_level:
		button_text.text = "[img widht=16 height=16]uid://d0cad5bhnnlc6[/img] " +str(upgrade_button_data.upgrade_effect_data.calculate_cost())
	if upgrade_count == upgrade_button_data.upgrade_effect_data.max_level:
		button_text.text = tr("MAX")
	header_container.visible = true
	description_container.visible = true
	enable_to_buy = true
	style.draw_center = true
	style.border_color = Color.WHITE
	#style.draw_center = true
func hide_description() -> void:
	if upgrade_count == upgrade_button_data.upgrade_effect_data.max_level:
		button_text.text = tr("MAX")
	else:
		button_text.text = upgrade_button_data.get_title_id
	header_container.visible = false
	description_container.visible = false
	enable_to_buy = false
	style.draw_center = false
	style.border_color = Color.TRANSPARENT
func _on_mouse_entered() -> void:
	show_description()
	
func _on_mouse_exited() -> void:
	if has_focus(): return
	hide_description()
