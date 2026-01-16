class_name BaseBullet extends Area2D

var target_type : UnitType
var current_damage : float
var _speed : float
var target_enemy
func setup(spawn_position : Vector2,speed : float,target_enemy : Node2D,damage : float,enemy : UnitType) -> void:
	self.target_enemy = target_enemy
	_speed = speed
	global_position = spawn_position
	target_type = enemy
	current_damage = damage
	
func on_collision_enemy() -> void:
	queue_free()
	pass
