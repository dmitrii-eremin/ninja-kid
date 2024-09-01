extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Score.text = "SCORE: %d" % Global.score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://menu/main_menu.tscn")
