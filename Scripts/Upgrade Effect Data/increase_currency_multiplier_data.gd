class_name IncreaseCurrencyMultiplierData extends UpgradeEffectData

func get_effect() -> void:
	GameManager.player_bonus.bonus_currency_multiplier += value * current_level
