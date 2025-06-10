extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Dialogic.VAR.mottrouver)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_switch_ecran_lettre()
	
func _switch_ecran_lettre():
	print(Dialogic.VAR.mottrouver)
	if Dialogic.VAR.mottrouver : 
		get_tree().change_scene_to_file("res://scenes/Findelaslice2/lettreentiere.tscn")
