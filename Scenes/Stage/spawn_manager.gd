class_name SpawnManager extends Node


@export var spawn_data : SpawnData
@export var direction_probability : TriggerProbability
@export var wave_index : int
@onready var game_scene: GameScene = $".."
@onready var wave_timer: GlobalTimer = $WaveTimer
@onready var spawn_timer: GlobalTimer = $SpawnTimer
var current_enemies : Array[PackedScene]
var current_spawn_time : float

func _ready() -> void:
	initialize()
	
func initialize() -> void:
	set_wave(0)
	spawn_timer.start()
	spawn_timer.autoplay = true
	wave_timer.start()
	spawn_timer.autoplay = true
	wave_timer.timeout.connect(_on_wave_time_timeout)
	spawn_timer.timeout.connect(_on_spawn_time_timeout)

func set_wave(index : int) -> void:
	wave_timer.wait_time = spawn_data.wave_datas[index].wave_time
	current_enemies =  spawn_data.wave_datas[index].enemies
	spawn_timer.wait_time = spawn_data.wave_datas[0].spawn_time
	
	
func _on_spawn_time_timeout() -> void:
	var enemy : BaseEnemy = get_random_enemy()
	
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = get_spawn_position()
	pass
	
func get_spawn_position() -> Vector2:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var direction = direction_probability.pickup_random(true)
	var final_position : Vector2 = Vector2.ZERO
	match direction.value:
		"UP":
			print("UP")
			final_position.y = game_scene.player.global_position.y - viewport_size.y / 2
			var x_pos = game_scene.player.global_position.x
			final_position.x = randfn(x_pos - viewport_size.x,x_pos + viewport_size.x)
			
		"DOWN":
			print("DOWN")
			final_position.y = game_scene.player.global_position.y + viewport_size.y / 2
			var x_pos = game_scene.player.global_position.x
			final_position.x = randfn(x_pos - viewport_size.x,x_pos + viewport_size.x)
			
		
		"LEFT":
			print("LEFT")
			final_position.x = game_scene.player.global_position.x - viewport_size.x / 2
			var y_pos = game_scene.player.global_position.y
			final_position.y = randfn(y_pos - viewport_size.y,y_pos + viewport_size.y)
			
		
		"RIGHT":
			print("RIGHT")
			final_position.x = game_scene.player.global_position.x + viewport_size.x / 2
			var y_pos = game_scene.player.global_position.y
			final_position.y = randfn(y_pos - viewport_size.y,y_pos + viewport_size.y)
	
	return final_position
	
func _on_wave_time_timeout() -> void:
	wave_index += 1
	if wave_index < spawn_data.wave_datas.size():
		set_wave(wave_index)
		
func get_random_enemy() -> BaseEnemy:
	return current_enemies.pick_random().instantiate()
