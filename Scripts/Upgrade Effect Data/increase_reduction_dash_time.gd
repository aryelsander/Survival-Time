class_name IncreaseReductionDashTimeData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_dash_wait_time += value * current_level
