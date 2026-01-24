class_name Player extends Area2D

signal die

@export_category("Movement")
@export var max_speed : float
@export var acceleration_speed : float
@export var deceleration_speed : float
@export_category("Combat")
@export var unit_type : UnitType
@export var target_type : UnitType
@export var max_hp : float
@export var damage : float
@export var shoot_speed : float
@export var shoot_distance_vision : float
@export var piercing_shoot : int
@export var time_to_find_target : float
@export var shield_size : float
@export var invulnerable_time : float
@export var blink_color : Color
@onready var dash_power: DashPower = $DashPower
@onready var shoot_power: ShootPower = $ShootPower
@onready var get_closest_enemy_timer: GlobalTimer = $GetClosestEnemyTimer
@onready var shield: Shield = $Shield
@onready var health_bar: HealthBar = $HealthBar
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var invulnerable_timer: GlobalTimer = $InvulnerableTimer
var current_hp : float
var game_scene : GameScene
var current_speed : float
var current_max_speed : float
var current_velocity : Vector2
var direction : Vector2
var current_direction : Vector2
var target : BaseEnemy
var color : Color
var base_invulnerable_time : float
var invulnerable_tween : Tween
var unlock_dash : bool = false
func _ready() -> void:
	color = modulate
	GameManager.player = self
	area_entered.connect(_on_area_entered)
	
	dash_power.dash_effect_timer.started.connect(dash)
	shoot_power.shoot_timer.timeout.connect(_on_shoot)
	dash_power.dash_effect_timer.completed.connect(exit_dash)
	health_bar.visible = false
	set_bonus()
	die.connect(on_die)
	current_max_speed = max_speed
	current_hp = max_hp
	health_bar.update_bar(current_hp / max_hp)
	invulnerable_timer.completed.connect(on_invulnerable_finish)

func set_bonus() -> void:
	GameManager.player_bonus = PlayerBonusData.new()
	for effect in GameManager.save_data.upgrade_list:
		var effect_reference: UpgradeEffectData = UpgradeManager.get_effect(effect.upgrade_id)
		effect_reference.get_effect()
	pass
	damage += GameManager.player_bonus.bonus_damage
	max_hp += GameManager.player_bonus.bonus_health
	max_speed += GameManager.player_bonus.bonus_max_speed
	piercing_shoot += GameManager.player_bonus.bonus_piercing
	invulnerable_timer.wait_time = invulnerable_time + GameManager.player_bonus.bonus_invulnerable_time
	unlock_dash = GameManager.player_bonus.unlocked_dash
	
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
	bullet_instance.setup(piercing_shoot,global_position,shoot_speed,target,damage,target_type)

func _process(_delta: float) -> void:
	get_target()
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	if Input.is_action_just_pressed("button_1") and dash_power.can_dash and unlock_dash:
		dash_power.dash_effect_timer.start()
	if Input.is_action_just_pressed("button_2"):
		shield.enable_shield()
	elif Input.is_action_just_released("button_2"):
		shield.disable_shield()
		
	if direction.length() != 0:
		current_speed = move_toward(current_speed,current_max_speed,acceleration_speed)
		current_velocity = current_speed * direction
		current_direction = direction
	else:
		current_speed = move_toward(current_speed,0,deceleration_speed)
		current_velocity = current_direction * current_speed	
	GameManager.global_time_speed = clamp(current_speed / current_max_speed,0,1)
	
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
	current_hp -= _value
	health_bar.update_bar(current_hp / max_hp)
	call_deferred("blink")
	if current_hp <= 0:
		die.emit()
	pass

func on_die() -> void:
	queue_free()

func _on_area_entered(area2d : Area2D) -> void:
	if area2d is BaseBullet:
		on_collision_bullet(area2d)
	
func blink() -> void:
	health_bar.visible = true
	collision_shape_2d.disabled = true
	invulnerable_tween = create_tween()
	invulnerable_tween.set_loops()
	invulnerable_tween.tween_property(self,"modulate",blink_color,0.08)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	invulnerable_tween.chain().tween_property(self,"modulate",color,0.08)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	invulnerable_tween.play()
	invulnerable_timer.start()
func on_invulnerable_finish() -> void:
	health_bar.visible = false
	collision_shape_2d.disabled = false
	invulnerable_tween.kill()
	invulnerable_timer.stop()
	invulnerable_timer.reload()
	modulate = color
