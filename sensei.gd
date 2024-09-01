extends CharacterBody2D

@export var max_hp = 10
@export var jump_speed = -300
@export var fade_out_speed = 0.25
var x_speed = 50
var dx = 1
@onready var current_hp = max_hp

var died = false
var died_vx = 0
var died_vy = 0

signal on_died

var is_battle_started = false
var Star = preload("res://cannon_ball.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func start_battle():
	$CanvasLayer/ProgressBar.max_value = max_hp
	$CanvasLayer/ProgressBar.value = current_hp
	$CanvasLayer/ProgressBar.visible = true
	is_battle_started = true


func hit():
	current_hp = clamp(current_hp - 1, 0, max_hp)
	_update_progress_bar()
	if current_hp == 0:
		_die()
	else:
		$WaitInFadeOutTimer.stop()
		$ShootTimer.stop()
		$WaitOnPositionTimer.stop()
		_on_wait_on_position_timer_timeout()


@onready var sensei_curve = get_parent().get_node("SenseiPoints").curve
var sensei_points = []
var current_point = 0
var shots = 3


func _ready() -> void:
	$AnimatedSprite2D.play()
	_update_progress_bar()
	for i in sensei_curve.point_count:
		sensei_points.append(sensei_curve.get_point_position(i))
		
	position = sensei_points[current_point]
	$WaitOnPositionTimer.start()
	

func _processAiFrame():
	pass


var tween
func _on_wait_on_position_timer_timeout() -> void:
	$CollisionShape2D.disabled = true
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	tween = create_tween()	
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1,0), fade_out_speed)
	tween.tween_callback(_on_faded_out)
	

func _on_wait_in_fade_out_timer_timeout() -> void:
	tween = create_tween()	
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1,1,1,1), fade_out_speed)
	tween.tween_callback(_on_faded_in)
	

func _on_shoot_timer_timeout() -> void:
	shoot()

	shots -= 1
	if shots > 0:
		$ShootTimer.wait_time = randf_range(1.5, 4)
		$ShootTimer.start()
	else:
		shots = randi_range(1, 3)
		$WaitOnPositionTimer.wait_time = randf_range(1, 4)
		$WaitOnPositionTimer.start()


func _on_faded_out():
	$WaitInFadeOutTimer.wait_time = randf_range(1, 3)
	$WaitInFadeOutTimer.start()
	var new_point = current_point
	while new_point == current_point:
		new_point = randi_range(0, sensei_points.size() - 1)
	current_point = new_point
	position = sensei_points[current_point]
	
func _on_faded_in():
	$CollisionShape2D.disabled = false
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	$ShootTimer.wait_time = randf_range(0.4, 0.7)
	$ShootTimer.start()


func shoot():
	var star = Star.instantiate()
	star.position = position
	var dx = -1
	var dy = 0

	star.position.x += dx * 10
	star.position.y += dy * 10
	star.fire(dx, dy)
	
	get_tree().get_current_scene().add_child(star)


func _physics_process(delta: float):
	if died or $CollisionShape2D.disabled:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()


func _process(delta: float) -> void:
	if not died:
		_processAiFrame()
	else:
		died_vy += delta * gravity
		position.x += died_vx * delta
		position.y += died_vy * delta
		if position.y > 1000:
			call_deferred("queue_free")



func _die():
	Global.score += 10000
	on_died.emit()
	died = true
	$CanvasLayer/ProgressBar.visible = false
	died_vx = 100
	died_vy = -100
	$CollisionShape2D.disabled = true


func _update_progress_bar():
	$CanvasLayer/ProgressBar.value = current_hp
