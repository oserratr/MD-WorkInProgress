extends Node3D

var player_in_area = false
var interaction_force = false
var interaction_objet_recup_1 = false
var interaction_without_carton = false
var timeline_active = false
var first_interaction = false
var first_interaction_end = false
var has_played_first_interaction_force := false

@export var interaction_objet: Node3D
@export var ui_interaction_mere: Control
@export var player: CharacterBody3D
@export var player_camera: Camera3D
@export var camera_vue_mere: Camera3D

var active_secondary_camera: Camera3D = null
var camera_switched := false
var current_timeline_name := ""  # ✅ pour savoir quelle timeline est en cours

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
		if interaction_objet_recup_1:
			_timeline_objet_recup_1()
		elif first_interaction:
			_timeline_objet_recup()
			first_interaction_end = true

func _state_dialogue():
	if first_interaction_end:
		interaction_objet_recup_1 = true
		first_interaction = false

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return

	cam.current = true
	camera_switched = true

	if player and "lock_movement" in player:
		player.lock_movement(true)
	else:
		print("Erreur : joueur non défini ou méthode lock_movement manquante.")

func _switch_to_player_camera():
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null

	if player and "lock_movement" in player:
		player.lock_movement(false)

func get_active_camera() -> Camera3D:
	return active_secondary_camera if active_secondary_camera else player_camera

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
	current_timeline_name = "FirstInteractionObjetTombe"  # ✅ suivi
	player.lock_movement(true)
	Dialogic.start_timeline(current_timeline_name)

func _timeline_objet_recup():
	timeline_active = true
	current_timeline_name = "objetrecup"  # ✅ suivi
	player.lock_movement(true)
	_switch_to_camera(camera_vue_mere)
	Dialogic.start_timeline(current_timeline_name)

func _timeline_objet_recup_1():
	timeline_active = true
	current_timeline_name = "objetrecup1"  # ✅ suivi
	player.lock_movement(true)
	_switch_to_camera(camera_vue_mere)
	Dialogic.start_timeline(current_timeline_name)

# ✅ Fin de timeline : on switch caméra uniquement pour certaines
func _on_dialogic_timeline_ended():
	print("Timeline terminée :", current_timeline_name)
	timeline_active = false
	player.lock_movement(false)

	if current_timeline_name in ["objetrecup", "objetrecup1"]:
		_switch_to_player_camera()
	current_timeline_name = ""  # reset
