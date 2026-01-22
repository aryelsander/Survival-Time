class_name ShootPower extends Node

@export var bullet : PackedScene
@export var shoot_time : float
@onready var shoot_timer: GlobalTimer = $shoot_timer
@export var bullet_pool : Array[BaseBullet] = []
func _ready() -> void:
	shoot_timer.wait_time = shoot_time
	create_pool()
func get_bullet() -> BaseBullet:
	for bullet_instance in bullet_pool:
		if not bullet_instance.visible:
			enable(bullet_instance)
			return bullet_instance
	
	var new_bullet : BaseBullet = create_new_bullet()
	enable(new_bullet)
	return new_bullet
	

func create_new_bullet() -> BaseBullet:
	var new_bullet = bullet.instantiate()
	bullet_pool.append(new_bullet)
	get_tree().current_scene.add_child.call_deferred(new_bullet)
	new_bullet.destroy.connect(disable)
	
	return new_bullet

func create_pool() -> void:
	for x in 100:
		var new_bullet : BaseBullet = create_new_bullet()
		disable(new_bullet)
	
func enable(base_bullet: BaseBullet) -> void:
	print("Chamou enable")
	
	base_bullet.visible = true
	base_bullet.process_mode = Node.PROCESS_MODE_INHERIT

func disable(base_bullet: BaseBullet) -> void:
	print("Chamou disable")
	base_bullet.visible = false
	base_bullet.process_mode = Node.PROCESS_MODE_DISABLED
		
