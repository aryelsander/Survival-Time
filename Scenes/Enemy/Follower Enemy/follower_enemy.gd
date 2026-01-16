class_name FollowerEnemy extends BaseEnemy
	
func _physics_process(_delta: float) -> void:
	if get_target():
		var direction = position.direction_to(target.position)
		position += direction * enemy_data.base_speed * GameManager.global_time_speed
