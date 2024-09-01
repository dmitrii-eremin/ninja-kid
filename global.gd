extends Node

const max_lives = 3

var score = 0
var lives = max_lives

var scene_after_timer = ""
var upcoming_level_name = ""


const SPIKES_LAYER = 1 << (8 - 1)    # collision layer 8


func reset_lives():
	lives = max_lives


func go_to_scene_after_timer(scene_name, _upcoming_level_name):
	scene_after_timer = scene_name
	upcoming_level_name = _upcoming_level_name
	get_tree().call_deferred("change_scene_to_file", "res://wait_timer.tscn")


func go_to_scene(scene_name, _upcoming_level_name):
	get_tree().call_deferred("change_scene_to_file", scene_name)
	

func load_passed_levels():
	var data = {
			"level_00": false,
			"level_01": false,
			"level_02": false,
			"level_10": false,
			"level_11": false,
			"level_boss": false,
		}
	if not FileAccess.file_exists("user://savegame.save"):
		return data
		
	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var content = file.get_as_text()
	return JSON.parse_string(content)
		

func set_level_passed(level_name, passed):
	var levels = load_passed_levels()
	levels[level_name] = passed
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(levels))
