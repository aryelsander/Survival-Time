class_name IncreasePiercingData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_piercing += value * current_level
