class_name IncreaseInvulnerableTimeData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_invulnerable_time += value * current_level
