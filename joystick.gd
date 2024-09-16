extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var os_name = OS.get_name()
	if os_name == "macOS" or os_name == "Windows" or os_name == "Linux":
		$CanvasLayer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_go_left_button_button_down() -> void:
	Input.action_press("move_left", 1)


func _on_go_left_button_button_up() -> void:
	Input.action_release("move_left")


func _on_go_right_button_button_down() -> void:
	Input.action_press("move_right", 1)


func _on_go_right_button_button_up() -> void:
	Input.action_release("move_right")


func _on_jump_button_button_down() -> void:
	Input.action_press("jump", 1)


func _on_jump_button_button_up() -> void:
	Input.action_release("jump")


func _on_fire_button_button_down() -> void:
	Input.action_press("attack", 1)


func _on_fire_button_button_up() -> void:
	Input.action_release("attack")
