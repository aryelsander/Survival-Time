class_name IncreaseMaxHealthData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_health += value * current_level
