extends Node2D

@export var label_text = "something"
@onready var original_x = position.x
var time_passed = RandomNumberGenerator.new().randi_range(0, 15)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = label_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	position.x = original_x + sin(time_passed * 2.3) * 10
