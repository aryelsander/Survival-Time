class_name IncreaseDashSpeedData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_dash_speed += value * current_level
