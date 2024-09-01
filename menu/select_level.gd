extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PickSound.play()
	
	var levels = Global.load_passed_levels()
	if levels["level_00"]:
		$Doors/Door00.position.x = -1000
	if levels["level_01"]:
		$Doors/Door01.position.x = -1000
	if levels["level_02"]:
		$Doors/Door02.position.x = -1000
	if levels["level_10"]:
		$Doors/Door10.position.x = -1000
	if levels["level_11"]:
		$Doors/Door11.position.x = -1000
	if levels["level_boss"]:
		$Doors/DoorBoss.position.x = -1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_00_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.go_to_scene_after_timer("res://levels/level_0_0.tscn", "0-0")


func _on_level_01_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.go_to_scene_after_timer("res://levels/level_0_1.tscn", "0-1")


func _on_level_02_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.go_to_scene_after_timer("res://levels/level_0_2.tscn", "0-2")


func _on_level_10_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.go_to_scene_after_timer("res://levels/level_1_0.tscn", "1-0")


func _on_level_11_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.go_to_scene_after_timer("res://levels/level_1_1.tscn", "1-1")


func _on_level_boss_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.go_to_scene_after_timer("res://levels/level_boss.tscn", "BOSS!")


func _on_back_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		get_tree().change_scene_to_file("res://menu/main_menu.tscn")
