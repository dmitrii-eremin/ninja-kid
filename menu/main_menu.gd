extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_demo_level_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return

	Global.go_to_scene_after_timer("res://levels/level_0_0.tscn", "0-0")


func _on_quit_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return
	get_tree().quit()


func _on_select_level_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return
	get_tree().change_scene_to_file("res://menu/select_level.tscn")


func _on_credits_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return
	get_tree().change_scene_to_file("res://credits.tscn")
