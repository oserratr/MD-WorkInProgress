extends Control

var elapsed_time := 0.0
var has_switched := false
const TIMEOUT := 60.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var my_music = preload("res://assets/Son/outro.mp3")
	AudioManager.play_music(my_music)

func _process(delta):
	if has_switched:
		return

	elapsed_time += delta

	if Input.is_action_just_pressed("PlayGame") or elapsed_time >= TIMEOUT:
		_switch_ecran_screentitle()

func _switch_ecran_screentitle():
	has_switched = true
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
