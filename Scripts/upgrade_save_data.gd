class_name UpgradeSaveData extends Resource

@export var upgrade_id : String
@export var total_upgrade_buyed : int

static func create(upgrade_id : String, total_upgrade_buyed: int) -> UpgradeSaveData:
	var upgrade_save_data = UpgradeSaveData.new()
	upgrade_save_data.upgrade_id = upgrade_id
	upgrade_save_data.total_upgrade_buyed = total_upgrade_buyed
	return upgrade_save_data
