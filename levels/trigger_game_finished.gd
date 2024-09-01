extends Area2D


func open():
	$MenuLabel.visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
