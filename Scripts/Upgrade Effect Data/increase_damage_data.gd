class_name IncreaseDamageData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_damage += value * current_level
