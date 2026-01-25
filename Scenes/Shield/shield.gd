class_name Shield extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var target_type : UnitType
@export var shield_size : float
@export var shield_time : float
@export var spend_shield_time : float
@export var current_shield_time : float
@export var recovery_shield_time : float
@export var overcharge_factor : float
var overcharge : bool = false
var can_use : bool:
	get:
		return current_shield_time  >= spend_shield_time
		
func _ready() -> void:
	area_entered.connect(_on_collision_bullet)
	scale = Vector2.ONE * shield_size
	#disable_shield()

func use_shield(delta: float,enable : bool) -> void:
	if enable and can_use and not overcharge:
		current_shield_time = clamp(current_shield_time - (spend_shield_time * GameManager.global_time_speed),0,shield_time)
		process_mode = Node.PROCESS_MODE_INHERIT
		visible = true	
	else:
		current_shield_time = clamp(current_shield_time + (recovery_shield_time * GameManager.global_time_speed),0,shield_time)
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		if current_shield_time < shield_time / overcharge_factor:
			overcharge = true
		else:
			overcharge = false
func _on_collision_bullet(bullet: Area2D) -> void:
	if bullet is BaseBullet:
		if bullet._target_type != target_type:
			bullet.on_collision_shield()
