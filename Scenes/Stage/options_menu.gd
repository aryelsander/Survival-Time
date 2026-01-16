class_name OptionsMenu extends Panel

@export var return_focus_control : Control

@onready var general_label: Label = $OptionsScrollContainer/VBoxContainer/GeneralLabel
@onready var language_label: Label = $OptionsScrollContainer/VBoxContainer/LanguageContainer/LanguageLabel
@onready var option_button: OptionButton = $OptionsScrollContainer/VBoxContainer/LanguageContainer/OptionButton
@onready var master_volume_label: Label = $OptionsScrollContainer/VBoxContainer/MasterVolumeContainer/MasterVolumeLabel
@onready var master_volume_slider: HSlider = $OptionsScrollContainer/VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var music_label: Label = $OptionsScrollContainer/VBoxContainer/MusicContainer/MusicLabel
@onready var music_slider: HSlider = $OptionsScrollContainer/VBoxContainer/MusicContainer/MusicSlider
@onready var sfx_label: Label = $OptionsScrollContainer/VBoxContainer/SFXContainer/SFXLabel
@onready var sfx_slider: HSlider = $OptionsScrollContainer/VBoxContainer/SFXContainer/SFXSlider
@onready var back_button: Button = $BackButton

signal open
signal close

var languages = [["ENGLISH","en"],["PORTUGUESE","pt"]]
func _ready() -> void:
	#GameManager.change_language.connect(update_ui)
	option_button.item_selected.connect(select_language)
	back_button.pressed.connect(_on_close)
	add_options_menu()
	call_deferred("update_ui")
	close.connect(_on_close)

func add_options_menu() -> void:
	option_button.clear()
	for idx in languages.size():
		option_button.add_item(tr(languages[idx][0]),idx)
		
func update_ui() -> void:
	general_label.text = tr("GENERAL")
	music_label.text = tr("MUSIC")
	language_label.text = tr("LANGUAGE")
	sfx_label.text = tr("SFX")
	back_button.text = tr("BACK")
	master_volume_label.text = tr("MASTER_VOLUME")
	for index in option_button.item_count:
		option_button.set_item_text(index,tr(languages[index][0]))
		
		if GameManager.configuration_data.language.contains(languages[index][1]):
			option_button.selected = index
	
func select_language(index : int) -> void:
	GameManager.set_language(languages[index][1])
	update_ui()
	GameManager.save_configuration_data(GameManager.configuration_data)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		set_focus()
		close.emit()

func set_focus() -> void:
	if return_focus_control:
		return_focus_control.grab_focus()

func _on_close() -> void:
	visible = false
