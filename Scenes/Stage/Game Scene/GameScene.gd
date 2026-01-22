class_name GameScene extends Node2D


@onready var world_environment: WorldEnvironment = $WorldEnvironment
#@export var time_to_boss : float
@onready var time_to_boss_timer: GlobalTimer = $TimeToBossTimer
@onready var time_count_text: RichTextLabel = $TimeCountText
@onready var spawn_manager: SpawnManager = $SpawnManager
@export var music : AudioStream
@export var frequency : float

var current_time_to_boss : float
var player : Player

func _ready() -> void:
	GameManager.game_scene = self
	set_time(current_time_to_boss)
	player = GameManager.player
	player.game_scene = self
	player.get_closest_enemy_timer.autoplay = true
	player.get_closest_enemy_timer.wait_time = player.time_to_find_target
	player.get_closest_enemy_timer.timeout.connect(get_enemy)
	player.get_closest_enemy_timer.start()
	AudioManager.play_music(music)
func _process(_delta: float) -> void:
	world_environment.environment.adjustment_saturation = clamp(GameManager.global_time_speed,0,1)
	set_time(time_to_boss_timer.time_left)

func get_enemy() -> void:
	var enemy := spawn_manager.get_closest_enemy(player)
	player.target = enemy

func get_enemies(target: Node2D,quantity: int,distance) -> Array[BaseEnemy]:
	return spawn_manager.get_closest_enemies(target,quantity,distance)

func set_time(time : float) -> void:
	var current_frequency = clamp((frequency * GameManager.global_time_speed),0,frequency)
	time_count_text.text = "[wave freq=%d]Time: " %[current_frequency] + seconds_to_time(time) + "[wave]"
	

func seconds_to_time(value: float) -> String:
	var total_seconds := int(value)
	var minutes : int = total_seconds / 60
	var seconds : int = total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]
