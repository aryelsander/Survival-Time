class_name MagicBullet extends BaseBullet

@export var range_scale : float
var _direction : Vector2
var _scale : Vector2

func setup(spawn_position : Vector2,speed : float,target : Node2D,damage : float,target_type : UnitType) -> void:
	super(spawn_position,speed,target,damage,target_type)
	_scale = scale
	pulse_effect()
	
func _physics_process(_delta: float) -> void:
	_direction = position.direction_to(_target.position)
	position += _speed * _direction * GameManager.global_time_speed

func pulse_effect() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale",_scale + Vector2(_scale.x * range_scale,_scale.y * range_scale),0.2)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.chain()
	tween.tween_property(self,"scale",_scale - Vector2(_scale.x * range_scale,_scale.y * range_scale),0.2)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.set_loops()
	tween.play()
