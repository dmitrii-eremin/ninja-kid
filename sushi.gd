extends Area2D

signal on_collected(sushi: Node2D, body: Node2D, price: int)

@export var price = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_mask_value(5, true)
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var already_collected = false
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or already_collected:
		return
	already_collected = true

	$Sound.play()
	visible = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	Global.score += price
	on_collected.emit(self, body, price)


func _on_sound_finished() -> void:
	call_deferred("queue_free")
