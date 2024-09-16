extends Control

enum MenuItem {
	CONTINUE, MAIN_MENU
}

@onready var selected_menu = MenuItem.CONTINUE
var can_press_cancel_again = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_place_pointer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not self.visible:
		return
	if Input.is_action_just_pressed("ui_down"):
		_next_menu()
	if Input.is_action_just_pressed("ui_up"):
		_prev_menu()
	if Input.is_action_just_pressed("ui_accept"):
		_select()
	if can_press_cancel_again and Input.is_action_just_pressed("ui_cancel"):
		selected_menu = MenuItem.CONTINUE
		_select()
		
	if Input.is_action_just_released("ui_cancel"):
		can_press_cancel_again = true


func show_menu():
	can_press_cancel_again = false
	self.visible = true
	selected_menu = MenuItem.CONTINUE


func _select():
	self.visible = false
	get_tree().paused = false

	if selected_menu == MenuItem.CONTINUE:
		# no action required, everything is already done above
		pass
	elif selected_menu == MenuItem.MAIN_MENU:
		get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _place_pointer():
	if selected_menu == MenuItem.CONTINUE:
		$Pointer.position.y = $Continue.position.y - $Pointer.size.y / 2
	elif selected_menu == MenuItem.MAIN_MENU:
		$Pointer.position.y = $MainMenu.position.y - $Pointer.size.y / 2


func _next_menu():
	if selected_menu == MenuItem.CONTINUE:
		selected_menu = MenuItem.MAIN_MENU
	elif selected_menu == MenuItem.MAIN_MENU:
		selected_menu = MenuItem.CONTINUE
	_place_pointer()
		

func _prev_menu():
	if selected_menu == MenuItem.CONTINUE:
		selected_menu = MenuItem.MAIN_MENU
	elif selected_menu == MenuItem.MAIN_MENU:
		selected_menu = MenuItem.CONTINUE
	_place_pointer()


func _on_continue_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		selected_menu = MenuItem.CONTINUE
		_select()


func _on_main_menu_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		selected_menu = MenuItem.MAIN_MENU
		_select()
