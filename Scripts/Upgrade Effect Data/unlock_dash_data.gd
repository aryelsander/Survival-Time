class_name UnlockDashData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.unlocked_dash = value
