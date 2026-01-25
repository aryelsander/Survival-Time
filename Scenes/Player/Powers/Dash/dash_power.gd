class_name DashPower extends Node

@export_category("Dash")
@export var dash_speed : float
@export var dash_effect_time : float
@onready var dash_effect_timer: GlobalTimer = $DashTimer

@export_category("Dash Cooldown")
@export var can_dash : bool
@export var dash_refresh_time : float
@onready var dash_refresh_timer: GlobalTimer = $DashRefresh

func _ready() -> void:
	
	dash_effect_timer.wait_time = dash_effect_time
	dash_refresh_timer.wait_time = dash_refresh_time - GameManager.player_bonus.bonus_dash_wait_time
	dash_refresh_timer._current_time = dash_refresh_timer.wait_time
	
	
	dash_effect_timer.started.connect(_on_dash_effect_start)
	dash_effect_timer.completed.connect(_on_dash_effect_completed)
	dash_refresh_timer.completed.connect(_on_dash_refresh_completed)
	
	
func _on_dash_effect_start() -> void:
	dash_refresh_timer.stop()
	can_dash = false
	
func _on_dash_refresh_completed() -> void:
	can_dash = true
	dash_effect_timer.stop()
	dash_effect_timer.reload()

func _on_dash_effect_completed() -> void:
	
	dash_effect_timer.stop()
	dash_refresh_timer.reload()
	dash_refresh_timer.start()
