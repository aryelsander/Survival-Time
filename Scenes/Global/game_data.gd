class_name GameData extends Resource

@export var currency : float
@export var upgrade_list : Array[UpgradeSaveData] = []

static func default() -> GameData:
	var game_data: GameData = GameData.new()
	game_data.currency = 0.0
	game_data.upgrade_list = []
	return game_data
