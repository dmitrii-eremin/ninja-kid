extends Node2D

@onready var original_y = position.y
@export var speed = 25
var dy = 0
var started = false

func open():
	started = true
	$RigidBody2D.set_collision_layer_value(1, false)
	$RigidBody2D.set_collision_mask_value(1, false)
	$RigidBody2D/CollisionShape2D.disabled = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started:
		position.y += delta * speed
		if position.y - original_y > 64:
			started = false


func _on_sensei_on_died() -> void:
	open()
	get_parent().get_node("MainUI").update_score()
