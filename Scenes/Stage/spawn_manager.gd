class_name SpawnManager extends Node

@export var spawn_data : SpawnData
@export var direction_probability : TriggerProbability
@export var wave_index : int
@onready var game_scene: GameScene = $".."
@onready var wave_timer: GlobalTimer = $WaveTimer
@onready var spawn_timer: GlobalTimer = $SpawnTimer
var current_enemies : Array[PackedScene]
var current_spawn_time : float
var current_enemy : BaseEnemy
var spawned_enemies : Array[BaseEnemy]
@onready var camera_2d: Camera2D = $"../Camera2D"

func _ready() -> void:
	initialize()
	
func initialize() -> void:
	set_wave(0)
	
	wave_timer.timeout.connect(_on_wave_time_timeout)
	spawn_timer.timeout.connect(_on_spawn_time_timeout)
	spawn_timer.autoplay = true
	spawn_timer.start()
	wave_timer.autoplay = true
	wave_timer.start()
func set_wave(index : int) -> void:
	wave_timer.wait_time = spawn_data.wave_datas[index].wave_time
	current_enemies =  spawn_data.wave_datas[index].enemies
	spawn_timer.wait_time = spawn_data.wave_datas[index].spawn_time
	
	
func _on_spawn_time_timeout() -> void:
	var enemy : BaseEnemy = get_random_enemy()
	spawned_enemies.append(enemy)
	enemy.spawn_manager = self
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = get_spawn_position()
	pass

func get_spawn_position() -> Vector2:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var direction = direction_probability.pickup_random(true)
	var final_position : Vector2 = Vector2.ZERO
	var visible_size : Vector2 = viewport_size
	var half_size : Vector2 = visible_size * 0.5
	var cam_pos : Vector2 = camera_2d.global_position

	var min_x = cam_pos.x - half_size.x
	var max_x = cam_pos.x + half_size.x
	var min_y = cam_pos.y - half_size.y
	var max_y = cam_pos.y + half_size.y

	match direction.value:
		"UP":
			final_position = Vector2(randf_range(min_x, max_x), min_y)
		"DOWN":
			final_position = Vector2(randf_range(min_x, max_x), max_y)
		"LEFT":
			final_position = Vector2(min_x, randf_range(min_y, max_y))
		"RIGHT":
			final_position = Vector2(max_x, randf_range(min_y, max_y))
	
	return final_position

func get_closest_enemy(target: Node2D) -> BaseEnemy:
	var closest: BaseEnemy = null
	var min_distance := INF
	
	for enemy in spawned_enemies:
		var distance := enemy.position.distance_to(target.position)
		if distance <= target.shoot_distance_vision and distance < min_distance:
			min_distance = distance
			closest = enemy
	
	return closest

func get_closest_enemies(target: Node2D, quantity: int,ricochet_distance : float) -> Array[BaseEnemy]:
	var result: Array[BaseEnemy] = []
	
	if not target:
		return result
	
	for enemy in spawned_enemies:
		var distance := enemy.position.distance_to(target.position)
		if distance <= ricochet_distance:
			result.append(enemy)
	
	result.sort_custom(func(a: BaseEnemy, b: BaseEnemy) -> bool:
		return a.position.distance_to(target.position) < b.position.distance_to(target.position)
	)
	if result.size() > quantity:
		result.resize(quantity)
	
	return result
	
func _on_wave_time_timeout() -> void:
	print("wave timeout")
	wave_index += 1
	if wave_index < spawn_data.wave_datas.size():
		set_wave(wave_index)
	else:
		wave_timer.stop()
		spawn_timer.stop()
		
func get_random_enemy() -> BaseEnemy:
	return current_enemies.pick_random().instantiate()
