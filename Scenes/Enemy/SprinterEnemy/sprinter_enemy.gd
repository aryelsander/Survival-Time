class_name SprinterEnemy extends BaseEnemy

func _physics_process(_delta: float) -> void:
	if get_target():
		look_at(target.position)
		var direction = position.direction_to(target.position)
		position += direction * enemy_data.base_speed * GameManager.global_time_speed
