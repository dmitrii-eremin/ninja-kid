extends RigidBody2D

@export var speed = 250

var Smoke = preload("res://smoke.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AppearSound.play()
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, true)
	set_collision_mask_value(5, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func fire(dx, dy):
	self.apply_central_impulse(speed * Vector2(dx, dy))
	self.set_angular_velocity(100)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") or body.is_in_group("cannon") or body.is_in_group("sensei"):
		body.hit()
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		visible = false
		if body.is_in_group("cannon") or body.is_in_group("sensei"):
			$HitSound.play()
	else:
		call_deferred("queue_free")
	
	var smoke = Smoke.instantiate()
	smoke.position = self.position
	get_parent().add_child(smoke)


func _on_hit_sound_finished() -> void:
	call_deferred("queue_free")
