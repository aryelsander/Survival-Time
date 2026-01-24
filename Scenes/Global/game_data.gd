class_name GameData extends Resource

signal increase
@export var currency : float
@export var upgrade_list : Array[UpgradeSaveData] = []
@export var first_time_in_game : bool
@export var first_time_in_upgrade : bool

static func default() -> GameData:
	var game_data: GameData = GameData.new()
	game_data.currency = 0.0
	game_data.upgrade_list = []
	game_data.first_time_in_game = true
	game_data.first_time_in_upgrade = true
	return game_data

func add_currency(value : float) -> void:
	currency += value
	increase.emit()

func increase_upgrade(id: String) -> void:
	for index in GameManager.save_data.upgrade_list.size():
		if upgrade_list[index].upgrade_id == id:
			GameManager.save_data.upgrade_list[index].total_upgrade_buyed += 1
			GameManager.save_game_data(GameManager.save_data)
			increase.emit()
			return
	
	GameManager.save_data.upgrade_list.append(UpgradeSaveData.create(id,1))
	GameManager.save_game_data(GameManager.save_data)
