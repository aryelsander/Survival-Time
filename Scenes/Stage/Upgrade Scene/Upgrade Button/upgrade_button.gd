class_name UpgradeButton extends Control

@export var upgrade_scene : UpgradeScene
@export var upgrade_button_data : UpgradeButtonData
@export var icon_currency: Texture2D
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
@export var upgrade_count : int
@export_multiline var description_text : String
func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.focus_entered.connect(show_description)
	button.focus_exited.connect(hide_description)
	button.pressed.connect(buy)
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
	get_effect_count()	
	quantity_label.text = str(upgrade_count ) + "/" + str(upgrade_button_data.points_data.upgrade_data.size())

	if upgrade_count < upgrade_button_data.points_data.upgrade_data.size():
		value_label.text = "[img widht=16 height=16]uid://vk01qri7gnda[/img] " +str(upgrade_button_data.points_data.upgrade_data[upgrade_count].cost)
		var currency : int = upgrade_button_data.points_data.upgrade_data[upgrade_count].cost
		button.disabled = GameManager.save_data.currency < currency
	else:
		button.disabled = true
		button.text = "MAX"
	#if GameManager.points < upgrade_button_data.points_data.upgrade_data[0].cost[0].value:
		#button.disabled = true

func buy() -> void:
	var currency : int = upgrade_button_data.points_data.upgrade_data[upgrade_count].cost
	if GameManager.save_data.currency >= currency:
		GameManager.save_data.currency -= currency
		add_upgrade()
		update_ui()
		upgrade_scene.update_ui()

func add_upgrade() -> void:
	for index in GameManager.save_data.upgrade_list.size():
		if GameManager.save_data.upgrade_list[index].upgrade_id == upgrade_button_data.points_data.upgrade_id:
			GameManager.save_data.upgrade_list[index].total_upgrade_buyed += 1
			GameManager.save_game_data(GameManager.save_data)
			print("Achou na lista e já incrementou")
			return
	
	print("Criou porque é um upgrade novo")
	GameManager.save_data.upgrade_list.append(UpgradeSaveData.create(upgrade_button_data.points_data.upgrade_id,1))
	GameManager.save_game_data(GameManager.save_data)
	print("Lista atualizada")
	for upgrade in GameManager.save_data.upgrade_list:
		print(upgrade.upgrade_id)
	

func get_effect_count() -> void:
	for upgrade in GameManager.save_data.upgrade_list:
		if upgrade.upgrade_id == upgrade_button_data.points_data.upgrade_id:
			upgrade_count = upgrade.total_upgrade_buyed
			print("Achou upgrade comprado")
			return
	print("Não achou upgrade")
	
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
