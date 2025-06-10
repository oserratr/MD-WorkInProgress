extends Node3D

var transition_lancee := false

func _process(delta):
	if Dialogic.VAR.mottrouver and not transition_lancee:
		transition_lancee = true
		_start_delayed_scene_switch()

func _start_delayed_scene_switch():
	print("mot trouvé, changement de scène dans 3 secondes…")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/Findelaslice2/lettreentiere.tscn")
