extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	$Texte.play("Blink")

func _process(delta):
	if Input.is_action_just_pressed("PlayGame") :
		$CanvasLayer/AnimationPlayer.play("disolve")
		await $CanvasLayer/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/Cutscene/mainintrocutscene.tscn")
		$CanvasLayer/AnimationPlayer.play_backwards("disolve")
	
