class_name UpgradeButtonData extends Resource

@export var title_id : String
@export var description_id: String
@export var upgrade_reference_id : String
var upgrade_effect_data : UpgradeEffectData

var get_description:
	get:
		return set_value(ControllerManager.set_button_configuration(tr(description_id),32))
var get_title_id:
	get:
		return tr(title_id)

func get_upgrade_effect() -> void:
	for upgrade in UpgradeManager.effects:
		if upgrade.upgrade_id == upgrade_reference_id:
			upgrade_effect_data = upgrade
			return
		
	print("Upgrade ID: " +  upgrade_reference_id +  " não mapeado no Upgrade Manager ou não existe")

func set_value(text: String) -> String:
	if text:
		return text.replace("#value#",str(upgrade_effect_data.value))
	return ""
