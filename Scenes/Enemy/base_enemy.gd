class_name BaseEnemy extends Area2D
var color : Color

signal death(base_enemy: BaseEnemy)
signal take_damage(damage : float)
signal collision_player(player : Player)
signal collision_bullet(bullet : BaseBullet)
@export var unit_type : UnitType
@export var enemy_data : EnemyData
@export var blink_color : Color
@export var take_damage_fx : AudioStream
var current_health : float
var target : Player
var spawn_manager : SpawnManager

func _ready() -> void:
	target = GameManager.player
	color = modulate
	current_health = enemy_data.base_health
	area_entered.connect(_on_area_entered)
	collision_bullet.connect(_on_collision_bullet)
	collision_player.connect(_on_collision_player)
	take_damage.connect(_on_take_damage)
	death.connect(_on_death)
	
func _on_take_damage(damage : float) -> void:
	AudioManager.play_fx(take_damage_fx,position)
	current_health -= damage
	
	if current_health <= 0:
		death.emit(self)

func get_target() -> bool:
	if target: return true
	target = GameManager.player
	return target != null

func _on_death(base_enemy : BaseEnemy) -> void:
	spawn_manager.spawned_enemies.erase(self)
	spawn_manager.get_closest_enemy(target)
	queue_free()

func _on_collision_bullet(bullet : BaseBullet) -> void:
	blink()
	take_damage.emit(bullet.current_damage)
	bullet.on_collision_enemy()

func _on_collision_player(player : Player) -> void:
	player.take_damage(enemy_data.base_damage)
	death.emit(self)
	queue_free()

func _on_area_entered(area : Area2D) -> void:
	if area is Player:
		collision_player.emit(area)
		
	if area is BaseBullet:
		if area._target_type == unit_type:
			collision_bullet.emit(area)

func blink() -> void:
	var tween = create_tween()
	tween.tween_property(self,"modulate",blink_color,0.05)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.chain().tween_property(self,"modulate",color,0.05)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	tween.play()
