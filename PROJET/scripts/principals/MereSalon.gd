extends Node3D

var player_in_area = false
var interaction_force = false
var interaction_objet_recup_1 = false
var interaction_without_carton = false
var timeline_active = false
var first_interaction = false
var first_interaction_end = false
var has_played_first_interaction_force := false  # ✅ ajouté

@export var interaction_objet: Node3D
@export var ui_interaction_mere: Control
@export var player: CharacterBody3D

func _ready():
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

func _process(delta):
	ui_interaction_mere.visible = player_in_area and not timeline_active
	_state_dialogue()

func _input(event):
	var player_drop_carton = interaction_objet.get_bool_carton_drop()
	if player_drop_carton: 
		_timeline_interaction_force()
		first_interaction = true

	if player_in_area and event.is_action_pressed("e") and not timeline_active:
		# ✅ Inverser l’ordre pour permettre à recup_1 de se lancer correctement
		if interaction_objet_recup_1:
			_timeline_objet_recup_1()
		elif first_interaction:
			_timeline_objet_recup()
			first_interaction_end = true

func _state_dialogue():
	if first_interaction_end:
		interaction_objet_recup_1 = true
		first_interaction = false

func _on_mother_dialogue_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("dedans : ", body.name)

func _on_mother_dialogue_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print("sort : ", body.name)

# ✅ Timeline ne se joue qu'une seule fois
func _timeline_interaction_force():
	if has_played_first_interaction_force:
		return
	has_played_first_interaction_force = true

	timeline_active = true
	player.lock_movement(true)
	Dialogic.start_timeline("FirstInteractionObjetTombe")

func _timeline_objet_recup():
	timeline_active = true
	player.lock_movement(true)
	Dialogic.start_timeline("objetrecup")

func _timeline_objet_recup_1():
	timeline_active = true
	player.lock_movement(true)
	Dialogic.start_timeline("objetrecup1")

func _on_dialogic_timeline_ended():
	print("Timeline terminée")
	timeline_active = false
	player.lock_movement(false)

func get_bool_interaction() -> bool:
	return first_interaction
