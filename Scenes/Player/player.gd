class_name Player extends Area2D

@export_category("Movement")
@export var max_speed : float
@export var acceleration_speed : float
@export var deceleration_speed : float
@export_category("Combat")
@export var unit_type : UnitType
@export var target_type : UnitType
@export var damage : float
@export var shoot_speed : float
@export var shoot_distance_vision : float
@export var collision_quantity : int
@export var time_to_find_target : float
@export var blink_color : Color
@onready var dash_power: DashPower = $DashPower
@onready var shoot_power: ShootPower = $ShootPower
@onready var get_closest_enemy_timer: GlobalTimer = $GetClosestEnemyTimer
var game_scene : GameScene
var current_speed : float
var current_max_speed : float
var current_velocity : Vector2
var direction : Vector2
var current_direction : Vector2
var target : BaseEnemy
var color : Color
func _ready() -> void:
	color = modulate
	GameManager.player = self
	area_entered.connect(_on_area_entered)
	current_max_speed = max_speed
	dash_power.dash_effect_timer.started.connect(dash)
	dash_power.dash_effect_timer.completed.connect(exit_dash)
	shoot_power.shoot_timer.timeout.connect(_on_shoot)
	
	
func bounds() -> void:
	position = clamp(position,0,get_viewport().get_visible_rect().size)

func on_collision_bullet(bullet : BaseBullet) -> void:
	if bullet._target_type == unit_type:
		take_damage(bullet.current_damage)
		bullet.on_collision_enemy()
	
func _on_shoot() -> void:
	if not target : return
	var bullet_instance: BaseBullet = shoot_power.get_bullet()
	bullet_instance.global_position = position
	bullet_instance.setup(collision_quantity,global_position,shoot_speed,target,damage,target_type)

func _process(_delta: float) -> void:
	get_target()
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	if Input.is_action_just_pressed("dash") and dash_power.can_dash:
		dash_power.dash_effect_timer.start()
	
	
	if direction.length() != 0:
		current_speed = move_toward(current_speed,current_max_speed,acceleration_speed)
		current_velocity = current_speed * direction
		current_direction = direction
	else:
		current_speed = move_toward(current_speed,0,deceleration_speed)
		current_velocity = current_direction * current_speed	
	GameManager.global_time_speed = current_speed / current_max_speed
	
func _physics_process(_delta: float) -> void:
	position += current_velocity * GameManager.global_time_speed

func dash() -> void:
	current_max_speed = dash_power.dash_speed
	current_speed = current_max_speed
func exit_dash() -> void:
	current_max_speed = max_speed
	
func get_target() -> void:
	pass
	#target = GameManager.game_scene.enemy

func take_damage(_value: float) -> void:
	blink()
	pass

func _on_area_entered(area2d : Area2D) -> void:
	if area2d is BaseBullet:
		on_collision_bullet(area2d)
	
func blink() -> void:
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(self,"modulate",blink_color,0.08)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.chain().tween_property(self,"modulate",color,0.08)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.play()
