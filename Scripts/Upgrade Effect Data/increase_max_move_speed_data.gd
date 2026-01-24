class_name IncreaseMaxMoveSpeedData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_max_speed += value * current_level
