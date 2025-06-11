extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var my_music = preload("res://assets/Son/outro.mp3")
	AudioManager.play_music(my_music)

func _process(delta):
	if Input.is_action_just_pressed("PlayGame"):
		_switch_ecran_screentitle()

func _switch_ecran_screentitle():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
