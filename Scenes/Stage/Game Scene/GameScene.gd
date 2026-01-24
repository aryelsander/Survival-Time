class_name GameScene extends Node2D

@onready var world_environment: WorldEnvironment = $WorldEnvironment
#@export var time_to_boss : float
@onready var time_to_boss_timer: GlobalTimer = $TimeToBossTimer
@onready var time_count_text: RichTextLabel = $TimeCountText
@onready var spawn_manager: SpawnManager = $SpawnManager
@export var music : AudioStream
@export var frequency : float
@onready var game_over_container: GameOverMenu = $CanvasLayer/GameOverContainer
@onready var first_time_tutorial: FirstTimeTutorialGameScene = $CanvasLayer/FirstTimeTutorial
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu

var current_time_to_boss : float
var player : Player
var total_currency : float
func _ready() -> void:
	if GameManager.save_data.first_time_in_game:
		first_time_tutorial.show()
		GameManager.global_time_speed = 0
		process_mode = Node.PROCESS_MODE_DISABLED
		
	GameManager.game_scene = self
	set_time(current_time_to_boss)
	player = GameManager.player
	player.die.connect(on_player_die)
	player.game_scene = self
	player.get_closest_enemy_timer.autoplay = true
	player.get_closest_enemy_timer.wait_time = player.time_to_find_target
	player.get_closest_enemy_timer.timeout.connect(get_enemy)
	player.get_closest_enemy_timer.start()
	AudioManager.play_music(music)
func _process(_delta: float) -> void:
	world_environment.environment.adjustment_saturation = clamp(GameManager.global_time_speed,0,1)
	set_time(time_to_boss_timer.time_left)
	if Input.is_action_just_pressed("pause"):
		pause_menu.open()
	
func on_enemy_die(enemy: BaseEnemy) -> void:
	total_currency += enemy.enemy_data.base_currency + (enemy.enemy_data.base_currency * GameManager.player_bonus.bonus_currency_multiplier)
	pass

func on_player_die() -> void:
	# Play Death Sound
	# Wait 2 Seconds to back to Upgrade Menu
	#get_tree().change_scene_to_file.call_deferred("res://Scenes/Stage/Upgrade Scene/upgrade_scene.tscn")
	call_deferred("end_game")
	pass

func end_game() -> void:
	GameManager.save_data.currency += total_currency
	game_over_container.show_menu(total_currency)
	GameManager.save_game_data(GameManager.save_data)
	game_over_container.retry_button.grab_focus()
	process_mode = Node.PROCESS_MODE_DISABLED

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
