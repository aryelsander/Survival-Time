class_name TankEnemy extends BaseEnemy

@export var pushback_force : float

func _ready() -> void:
	super()
	collision_player.connect(pushback)

func _physics_process(_delta: float) -> void:
	if get_target():
		var direction = position.direction_to(target.position)
		position += direction * enemy_data.base_speed * GameManager.global_time_speed

func pushback(player : Player) -> void:
	var direction = -position.direction_to(target.position)
	player.position += -direction * pushback_force
	pass
