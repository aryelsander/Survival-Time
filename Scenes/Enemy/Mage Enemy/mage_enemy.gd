class_name MageEnemy extends BaseEnemy

@export_category("Shoot")
@export var shoot_distance : float
@export var shoot_time : float
@export var shoot_damage : float
@export var shoot_speed : float
@export var shoot_time_to_destroy : float
@export var bullet : PackedScene
@export var target_type : UnitType
@export_category("Movement")
@export var flee_distance : float
@export var min_rotation_time : float
@export var max_rotation_time : float
@export var change_direction_probability: TriggerProbability

@onready var rotation_timer: GlobalTimer = $RotationTimer
@onready var shoot_timer: GlobalTimer = $ShootTimer
var target_direction : Vector2
var rotation_direction : float
var ready_to_shoot : bool
func _ready() -> void:
	super._ready()
	ready_to_shoot = false
	shoot_timer.wait_time = shoot_time
	_pick_random_shoot_rotation()
	rotation_timer.timeout.connect(_pick_random_shoot_rotation)
	shoot_timer.start()
	shoot_timer.timeout.connect(func(): ready_to_shoot = false)
	shoot_timer.completed.connect(func(): ready_to_shoot = true)
	shoot_timer.timeout.connect(shoot)
	

func _physics_process(_delta: float) -> void:
	if get_target():
		if position.distance_to(target.position) > shoot_distance:
			var direction = position.direction_to(target.position)
			position += direction * enemy_data.base_speed * GameManager.global_time_speed
		elif position.distance_to(target.position) <= flee_distance:
			var direction = -position.direction_to(target.position)
			position += direction * enemy_data.base_speed * GameManager.global_time_speed
		elif position.distance_to(target.position) <= shoot_distance:
			if ready_to_shoot:
				target_direction = position.direction_to(target.position)
				shoot_timer.finish()
				
			var direction = position.direction_to(target.position).orthogonal() * rotation_direction
			position += direction * (enemy_data.base_speed / 2) * GameManager.global_time_speed
			pass

func shoot() -> void:
	var bullet_instance : BaseBullet = bullet.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = position
	bullet_instance.setup(global_position,shoot_speed,target,shoot_damage,target_type)
	var bullet_destroy_timer = GlobalTimer.new()
	bullet_destroy_timer.autoplay = true
	bullet_destroy_timer.wait_time = shoot_time_to_destroy
	bullet_instance.add_child(bullet_destroy_timer)
	bullet_destroy_timer.timeout.connect(func ():bullet_instance.queue_free())

func _pick_random_shoot_rotation() -> void:
	rotation_direction = change_direction_probability.pickup_random().value
	rotation_timer.wait_time = randf_range(min_rotation_time,max_rotation_time)
