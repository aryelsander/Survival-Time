class_name UnlockShieldData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.unlocked_shield = value
