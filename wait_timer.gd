extends Control

@export var seconds = 3
signal on_timer_expired()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PickSound.play()
	$CanvasLayer/LevelName.text = Global.upcoming_level_name
	$CanvasLayer/LivesCount.text = "x" + str(Global.lives)
	$CanvasLayer/Score.text = "Score: " + str(Global.score)
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	seconds -= 1
	update_text()
	if seconds > 0:
		$PickSound.play()
	if seconds <= 0:
		$PickSound2.play()
		$Timer.stop()
		
func update_text():
	$CanvasLayer/SecondsLeft.text = str(seconds)


func _on_pick_sound_2_finished() -> void:
	on_timer_expired.emit()
	get_tree().call_deferred("change_scene_to_file", Global.scene_after_timer)
