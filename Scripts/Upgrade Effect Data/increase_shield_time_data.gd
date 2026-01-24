class_name IncreaseShieldTimeData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_shield_time += value * current_level
