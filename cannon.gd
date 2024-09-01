extends StaticBody2D

@export var direction = "left"
@export var delay = 1.5

signal on_collected(cannon: Node2D, body: Node2D, price: int)

var price = 50

var CannonBall = preload("res://cannon_ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation = direction
	$Timer.wait_time = delay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var ball = CannonBall.instantiate()
	ball.position = self.position
	if direction == "left":
		ball.position.x -= 20
		ball.fire(-1, 0)
	elif direction == "right":
		ball.position.x += 20
		ball.fire(1, 0)
	elif direction == "down":
		ball.position.y += 20
		ball.fire(0, 1)
	else:
		return
	get_parent().add_child(ball)
	
func hit():
	Global.score += price
	on_collected.emit(self, null, price)
	call_deferred("queue_free")
