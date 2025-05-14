extends Node3D

var carton_pris:= false
var player_enter_objet:= false
@export var ui_interaction_prendre = Control
@export var carton_pickable: Node3D
@export var dialogue = Node3D
var player_enter_salon := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var interaction_mother = dialogue.get_bool_interaction()
	
	#affiche l'ui
	if player_enter_objet and not carton_pris and not interaction_mother :
		ui_interaction_prendre.visible = true
	else:
		ui_interaction_prendre.visible = false
		
	_interaction_carton()
	_switch_salon()

func _interaction_carton():
	var interaction_mother = dialogue.get_bool_interaction()
	if not interaction_mother and player_enter_objet:
		if Input.is_action_just_pressed("e"):
			print("prendre carton")
			carton_pickable.queue_free()
			carton_pris = true
			

func _on_carton_2_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_carton_2_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false

func get_bool_carton_pris() -> bool:
	return carton_pris

func _switch_salon():
	var interaction_mother = dialogue.get_bool_interaction()
	
	if player_enter_salon and Input.is_action_just_pressed("e"): 
		if not interaction_mother :
			get_tree().change_scene_to_file("res://scenes/niveaux/salon.tscn")
		
func _on_salon_body_entered(body):
	if body.is_in_group("player"):
		player_enter_salon = true


func _on_salon_body_exited(body):
	if body.is_in_group("player"):
		player_enter_salon = false
