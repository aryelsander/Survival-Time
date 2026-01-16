class_name ShootPower extends Node

@export var bullet : PackedScene
@export var shoot_time : float
@onready var shoot_timer: GlobalTimer = $shoot_timer

func _ready() -> void:
	shoot_timer.wait_time = shoot_time

func get_bullet() -> BaseBullet:
	return bullet.instantiate()
