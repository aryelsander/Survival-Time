class_name Shield extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var target_type : UnitType
@export var shield_size : float

func _ready() -> void:
	area_entered.connect(_on_collision_bullet)
	scale = Vector2.ONE * shield_size
	disable_shield()
	
func disable_shield() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	
func enable_shield() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
func _on_collision_bullet(bullet: Area2D) -> void:
	if bullet is BaseBullet:
		print("Tiro do Inimigo: " + str(bullet._target_type.type))
		if bullet._target_type != target_type:
			bullet.on_collision_shield()
