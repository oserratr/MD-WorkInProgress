extends Node3D

var player_in_area = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("e"):
			Dialogic.start_timeline("AlbumPhoto")
			print("startdialogue")
	
func _on_mother_dialogue_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("dedans")

func _on_mother_dialogue_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print("sort")
