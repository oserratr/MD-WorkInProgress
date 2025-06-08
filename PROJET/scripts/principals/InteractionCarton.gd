extends Node3D

var carton_pris := false
var player_enter_objet := false
var player_enter_salon := false

@export var ui_interaction_prendre: Control
@export var carton_pickable: Node3D
@export var dialogue: Node3D

func _process(delta):
	var interaction_mother = dialogue.get_bool_interaction()

	# Affichage UI si :
	# - le joueur est dans la zone du carton ET peut le prendre
	# - OU dans la zone de la porte ET peut changer de scène
	if (player_enter_objet and not carton_pris and not interaction_mother) \
		or (player_enter_salon and not interaction_mother and carton_pris):
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

func _switch_salon():
	var interaction_mother = dialogue.get_bool_interaction()
	if player_enter_salon and Input.is_action_just_pressed("e") and carton_pris:
		if not interaction_mother:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			$"../CanvasLayer/AnimationPlayer".play("disolve")
			await $"../CanvasLayer/AnimationPlayer".animation_finished
			get_tree().change_scene_to_file("res://scenes/niveaux/salon.tscn")
			$"../CanvasLayer/AnimationPlayer".play_backwards("disolve")
# Zones : carton
func _on_carton_2_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_carton_2_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false

# Zones : porte vers salon
func _on_salon_body_entered(body):
	if body.is_in_group("player"):
		player_enter_salon = true

func _on_salon_body_exited(body):
	if body.is_in_group("player"):
		player_enter_salon = false

func get_bool_carton_pris() -> bool:
	return carton_pris
