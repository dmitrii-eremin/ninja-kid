extends CharacterBody2D

signal on_hp_changed(hp: int)

@export var jump_speed = -250
@export var max_moving_speed = 60
var wall_slide_speed = 50
var rest_jump_speed = 50
var direction = 0
var last_direction = 1

var is_right_pressed = false
var is_left_pressed = false
var is_jump_pressed = false

var max_jumps_count = 2
var jumps_count = max_jumps_count
var is_jumped_off_the_wall = false
var is_jumped_off_the_wall_hit_once = false
var jump_off_direction = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Star = preload("res://cannon_ball.tscn")

var is_respawning = false
var can_throw_star = true


func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(5, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(8, true)


func _throw_star():
	var star = Star.instantiate()
	star.position = position
	var dx = 0
	var dy = 0
	
	if Input.is_action_pressed("look_up"):
		dy -= 1
	else:
		if is_on_left_wall():
			dx = 1
		elif is_on_right_wall():
			dx = -1
		elif last_direction < 0:
			dx = -1
		else:
			dx = 1
		
	star.position.x += dx * 10
	star.position.y += dy * 10
	star.fire(dx, dy)
	
	get_tree().get_current_scene().add_child(star)

	can_throw_star = false
	$StarTimer.start()


func _process(_delta: float) -> void:
	$AnimatedSprite2D.flip_h = last_direction < 0
	$AnimatedSprite2D.play()
	
	if can_throw_star and Input.is_action_just_pressed("attack"):
		_throw_star()

func hit():
	if is_respawning:
		return
	var hit_speed = jump_speed / 1.5

	Global.lives = max(Global.lives - 1, 0)
	if Global.lives == 0:
		$PlayerLose.play()
	else:
		$PlayerHit.play()
	on_hp_changed.emit(Global.lives)

	velocity = Vector2(hit_speed if randi_range(0, 1) == 0 else -hit_speed, hit_speed if is_on_floor() else -hit_speed)
	is_respawning = true
	set_collision_layer_value(5, false)
	$RespawnTimer.start()


func _physics_process(delta):
	var is_sliding = false

	_read_input()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_count = max_jumps_count
		if is_jumped_off_the_wall:
			is_jumped_off_the_wall = false
			is_left_pressed = Input.is_action_pressed("move_left")
			is_right_pressed = Input.is_action_pressed("move_right")
			
	if is_jumped_off_the_wall and is_on_wall():
		if not is_jumped_off_the_wall_hit_once:
			is_jumped_off_the_wall_hit_once = true
			
	if is_jumped_off_the_wall and is_jumped_off_the_wall_hit_once and not is_on_wall():
		is_jumped_off_the_wall = false
		is_jumped_off_the_wall_hit_once = false
		is_left_pressed = Input.is_action_pressed("move_left")
		is_right_pressed = Input.is_action_pressed("move_right")
		
		
	if is_jumped_off_the_wall:
		if is_on_right_wall():
			is_right_pressed = true
			is_left_pressed = false
		if is_on_left_wall():
			is_left_pressed = true
			is_right_pressed = false
		
	if velocity.y > 0 and ((is_on_right_wall() and is_right_pressed) or (is_on_left_wall() and is_left_pressed)):
		velocity.y = min(velocity.y, wall_slide_speed)
		jumps_count = max_jumps_count
		if is_jump_pressed:
			is_jumped_off_the_wall = true
			jump_off_direction = 1 if is_left_pressed else -1
			is_right_pressed = false
			is_left_pressed = false
		else:
			is_sliding = true
			
	if is_jump_pressed and jumps_count > 0:
		jumps_count -= 1
		velocity.y = jump_speed
		$Sounds/Jump.play()
		
	if is_left_pressed and not is_right_pressed:
		last_direction = -1
		velocity.x = -max_moving_speed
	elif is_right_pressed and not is_left_pressed:
		last_direction = 1
		velocity.x = max_moving_speed
	elif is_jumped_off_the_wall:
		velocity.x = max_moving_speed * jump_off_direction
	else:
		velocity.x = 0
	
	move_and_slide()
	_check_collisions()

	
	if is_sliding:
		$AnimatedSprite2D.animation = "slide"
	elif not is_on_floor():
		$AnimatedSprite2D.animation = "jump"
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "default"


func _read_input():
	is_jump_pressed = false
	if Input.is_action_just_pressed("jump"):
		is_jump_pressed = true
	if Input.is_action_just_pressed("move_right"):
		is_right_pressed = true
	if Input.is_action_just_pressed("move_left"):
		is_left_pressed = true
	if Input.is_action_just_released("move_right"):
		is_right_pressed = false
		#is_jumped_off_the_wall = false
	if Input.is_action_just_released("move_left"):
		is_left_pressed = false
		#is_jumped_off_the_wall = false
		

# for spikes checking
func _check_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			var tile_rid = collision.get_collider_rid()
			var collision_layer = PhysicsServer2D.body_get_collision_layer(tile_rid)
			if (collision_layer & Global.SPIKES_LAYER) != 0:
				hit()
		elif collider.is_in_group("sensei"):
			hit()


func is_on_left_wall(only: bool = false) -> bool:
	var count = get_slide_collision_count()
	if only and count > 1:
		return false
	for i in count:
		var norm = get_slide_collision(i).get_normal()
		if norm.x > 0.7:
			return true
	return false


func is_on_right_wall(only: bool = false) -> bool:
	var count = get_slide_collision_count()
	if only and count > 1:
		return false
	for i in count:
		var norm = get_slide_collision(i).get_normal()
		if norm.x < -0.7:
			return true
	return false


func _on_respawn_timer_timeout() -> void:
	is_respawning = false
	visible = true
	set_collision_layer_value(5, true)


func _on_blink_timer_timeout() -> void:
	if not is_respawning:
		return
	visible = not visible


func _on_star_timer_timeout() -> void:
	can_throw_star = true
