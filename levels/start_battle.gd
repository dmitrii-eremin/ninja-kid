extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return
	var sensei = get_tree().get_root().get_node("Level-BOSS").get_node("Sensei")
	if sensei != null:
		sensei.start_battle()
