extends Node2D

@onready var sushi_count = get_sushi_count()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ninja.set_pos($StartPoint.position)
	$MainUI.update_sushi_count(sushi_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		$MainUI.show_pause()


func get_sushi_count():
	var sushies = get_node("Sushies")
	if sushies == null:
		return 0
	return sushies.get_child_count(true)


func _on_sushi_on_collected(sushi: Node2D, body: Node2D, price: int) -> void:
	$MainUI.update_score()
	sushi_count -= 1
	$MainUI.update_sushi_count(sushi_count)


func _on_ninja_on_hp_changed(hp: int) -> void:
	Global.lives = hp
	if Global.lives == 0:
		Global.reset_lives()
		$Ninja.set_pos($StartPoint.position)
	$MainUI.update_hp()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return
	var filename = $Triggers/NextScene.get_meta("level_filename")
	var name = $Triggers/NextScene.get_meta("level_name")
	var no_wait = $Triggers/NextScene.get_meta("no_wait")
	var save_filename = $Triggers/NextScene.get_meta("savename")
	if save_filename:
		Global.set_level_passed(save_filename, true)
	if no_wait:
		Global.go_to_scene(filename, name)
	else:
		Global.go_to_scene_after_timer(filename, name)
