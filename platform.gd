extends Node2D

@export var offset = Vector2(100, 0)
@export var speed = 25
@export var initial_delay: float = 0.0

@onready var duration = offset.length() / speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InitialDelayTimer.wait_time = initial_delay
	$InitialDelayTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2D, "position", offset, duration / 2)
	tween.tween_property($AnimatableBody2D, "position", Vector2.ZERO, duration / 2)


func _on_initial_delay_timer_timeout() -> void:
	start_tween()
