extends Control

@onready var visible_score = Global.score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hp()
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible_score < Global.score:
		visible_score = clamp(visible_score + 4, 0, Global.score)
		update_score()
	

func show_pause():
	$CanvasLayer/PauseMenu.show_menu()

	
func update_score():
	$CanvasLayer/Score.text = "Score: " + str(visible_score)
	
func update_sushi_count(sushi_count):
	$CanvasLayer/Sushi/Count.text = "x%d" % sushi_count


func update_hp():
	$CanvasLayer/HPBar/First.visible = false
	$CanvasLayer/HPBar/Second.visible = false
	$CanvasLayer/HPBar/Third.visible = false

	if Global.lives >= 1:
		$CanvasLayer/HPBar/First.visible = true
	if Global.lives >= 2:
		$CanvasLayer/HPBar/Second.visible = true
	if Global.lives >= 3:
		$CanvasLayer/HPBar/Third.visible = true
