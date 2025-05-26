extends Node2D

@export var video_player = VideoStreamPlayer

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	video_player.finished.connect(_on_video_finished)

func _on_video_finished():
	get_tree().change_scene_to_file("res://scenes/niveaux/grenier.tscn")  # Remplace par le chemin de ta scène suivante

