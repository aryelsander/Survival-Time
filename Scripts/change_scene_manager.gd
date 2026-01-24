extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect

func change_scene(path: String) -> void:
	visible = true
	
	var change_scene_tween : Tween = create_tween()
	color_rect.scale = Vector2.ZERO
	change_scene_tween.tween_property(color_rect,"scale",Vector2(2.0,2.0),0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	change_scene_tween.step_finished.connect(func(idx: int): on_change(idx,path))
	change_scene_tween.tween_property(color_rect,"scale",Vector2.ZERO,0.5)
	change_scene_tween.finished.connect(func(): visible = false)
	change_scene_tween.play()
	
func on_change(idx : int,path : String) -> int:
	if idx == 0:
		get_tree().change_scene_to_file(path)
	return 0

func on_reload(idx : int,reload : SceneTree) -> int:
	if idx == 0:
		reload.reload_current_scene()
	return 0

func reload_scene(scene_to_reload : SceneTree) -> void:
	visible = true
	
	var change_scene_tween : Tween = create_tween()
	color_rect.scale = Vector2.ZERO
	change_scene_tween.tween_property(color_rect,"scale",Vector2(2.0,2.0),0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_LINEAR)
	change_scene_tween.step_finished.connect(func(idx: int): on_reload(idx,scene_to_reload))
	change_scene_tween.tween_property(color_rect,"scale",Vector2.ZERO,0.5)
	change_scene_tween.finished.connect(func(): visible = false)
	change_scene_tween.play()
