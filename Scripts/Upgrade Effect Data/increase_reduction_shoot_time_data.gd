class_name IncreaseReductionShootTimeData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_shoot_wait_time += value * current_level
