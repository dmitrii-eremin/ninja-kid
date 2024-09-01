extends Node2D

signal on_hp_changed(hp: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("whole_level") and OS.is_debug_build():
		$Ninja/Camera2D.zoom.x -= 0.25
		$Ninja/Camera2D.zoom.y -= 0.25


func _on_ninja_on_hp_changed(hp: int) -> void:
	on_hp_changed.emit(hp)

func set_pos(pos):
	$Ninja.position = pos
