class_name PhysicalBullet extends BaseBullet

var _direction : Vector2

func setup(spawn_position : Vector2,speed : float,target_enemy : Node2D,damage : float,enemy : UnitType) -> void:
	super(spawn_position,speed,target_enemy,damage,enemy)
	_direction = spawn_position.direction_to(target_enemy.position)
	rotation_degrees = rad_to_deg(position.direction_to(target_enemy.position).angle())

func _physics_process(_delta: float) -> void:
	position += _speed * _direction * GameManager.global_time_speed
