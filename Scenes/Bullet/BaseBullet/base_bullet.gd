class_name BaseBullet extends Area2D

var _target_type : UnitType
var current_damage : float
var _speed : float
var _target : Node2D
func setup(spawn_position : Vector2,speed : float,target : Node2D,damage : float,target_type : UnitType) -> void:
	_target = target
	_speed = speed
	global_position = spawn_position
	_target_type = target_type
	current_damage = damage
	
func on_collision_enemy() -> void:
	queue_free()
	pass
