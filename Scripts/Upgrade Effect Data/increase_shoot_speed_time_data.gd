class_name IncreaseShootSpeedTimeData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_shoot_speed += value * current_level
