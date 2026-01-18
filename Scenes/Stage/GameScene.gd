class_name GameScene extends Node2D
@onready var world_environment: WorldEnvironment = $WorldEnvironment
#@export var time_to_boss : float
@onready var time_to_boss_timer: GlobalTimer = $TimeToBossTimer
@onready var time_count_text: RichTextLabel = $TimeCountText

@export var enemy : BaseEnemy
@export var frequency : float

var current_time_to_boss : float
var player : Player
func _ready() -> void:
	GameManager.game_scene = self
	#current_time_to_boss = time_to_boss
	set_time(current_time_to_boss)
	player = GameManager.player
func _process(_delta: float) -> void:
	world_environment.environment.adjustment_saturation = clamp(GameManager.global_time_speed,0,1)
	set_time(time_to_boss_timer.time_left)

func get_closest_enemy() -> BaseEnemy:
	return null


func set_time(time : float) -> void:
	var current_frequency = clamp((frequency * GameManager.global_time_speed),0,frequency)
	time_count_text.text = "[wave freq=%d]Time: " %[current_frequency] + seconds_to_time(time) + "[wave]"
	

func seconds_to_time(value: float) -> String:
	var total_seconds := int(value)
	var minutes : int = roundi(total_seconds / 60.0)
	var seconds : int = total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]
