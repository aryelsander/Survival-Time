class_name UpgradeEffectData extends Resource

enum CostBased{
	LINEAR,
	LINEAR_INCREMENTAL,
	EXPONENCIAL,
	QUADRATIC,
	LOG,
}
@export var value : Variant
@export var upgrade_id : String
@export var max_level : int
@export var cost : float
@export var factor : float
@export var cost_based : CostBased
var current_level

func get_effect() -> void:
	pass

func calculate_cost() -> float:
	match cost_based:
		CostBased.LINEAR:
			return cost * (1 + current_level)
		CostBased.LINEAR_INCREMENTAL:
			return cost + ((current_level) * factor)
		CostBased.EXPONENCIAL:
			return cost * pow(factor,current_level)
		CostBased.QUADRATIC:
			return cost * (1 + current_level) * (1 + current_level)
		CostBased.LOG:
			return cost * (1.0 / (1.0 + exp(-factor * (current_level - (max_level / 2.0)))))
	return 0
