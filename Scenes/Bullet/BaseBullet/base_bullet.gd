class_name BaseBullet extends Area2D

signal collision_enemy(base_bullet: BaseBullet)
signal destroy
var _target_type : UnitType
var current_damage : float
var _speed : float
var _target : Node2D
var _collision_quantity : int
func setup(collision_quantity : int,spawn_position : Vector2,speed : float,target : Node2D,damage : float,target_type : UnitType) -> void:
	_collision_quantity = collision_quantity
	_target = target
	_speed = speed
	global_position = spawn_position
	_target_type = target_type
	current_damage = damage
	
func on_collision_enemy() -> void:
	_collision_quantity -=1
	collision_enemy.emit(self)
	if _collision_quantity <= 0:
		destroy.emit(self)
	pass

func on_collision_shield() -> void:
	destroy.emit(self)
