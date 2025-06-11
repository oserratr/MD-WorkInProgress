extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var my_music = preload("res://assets/Son/lettre.mp3")
	AudioManager.play_music(my_music)
