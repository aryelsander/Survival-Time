class_name PhysicalBullet extends BaseBullet

var _direction : Vector2

func setup(spawn_position : Vector2,speed : float,target : Node2D,damage : float,target_type : UnitType) -> void:
	super(spawn_position,speed,target,damage,target_type)
	_direction = spawn_position.direction_to(target.position)
	rotation_degrees = rad_to_deg(position.direction_to(target.position).angle())

func _physics_process(_delta: float) -> void:
	position += _speed * _direction * GameManager.global_time_speed
