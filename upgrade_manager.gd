extends Node

@export var effects : Array[UpgradeEffectData]

func get_effect(upgrade_id : String) -> UpgradeEffectData:
	for effect in effects:
		if upgrade_id == effect.upgrade_id:
			return effect
	return null
