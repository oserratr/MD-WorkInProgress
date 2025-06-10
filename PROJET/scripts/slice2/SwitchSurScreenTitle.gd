extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta):
	if Input.is_action_just_pressed("PlayGame"):
		_switch_ecran_screentitle()

func _switch_ecran_screentitle():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
