extends Node3D

var player_in_area_cousin = false
var interaction_force = false

@export var interaction_objet: Node3D
@export var ui_interaction_cousin: Control
@export var player: CharacterBody3D
@export var player_camera: Camera3D
@export var camera_vue_cousin: Camera3D

var active_secondary_camera: Camera3D = null
var camera_switched := false
var current_timeline_name := ""

func _ready():
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

func _process(delta):
	ui_interaction_cousin.visible = player_in_area_cousin

#func _input(event):
		

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

# Signal connecter area
func _on_vue_cousin_body_entered(body):
	if body.is_in_group("player"):
		player_in_area_cousin = true
		print("dedans : ", body.name)


func _on_vue_cousin_body_exited(body):
	if body.is_in_group("player"):
		player_in_area_cousin = false
		print("sort : ", body.name)
		
# Fonctions timelines
func _timeline_interaction_force():
	current_timeline_name = "FirstInteractionObjetTombe"
	player.lock_movement(true)
	Dialogic.start_timeline(current_timeline_name)

func _on_dialogic_timeline_ended():
	print("Timeline terminée :", current_timeline_name)
	player.lock_movement(false)

	if current_timeline_name in ["objetrecup", "objetrecup1"]:
		_switch_to_player_camera()

	current_timeline_name = ""



