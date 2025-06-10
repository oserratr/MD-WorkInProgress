extends Node3D

var player_in_area_cousin = false
var current_timeline_name := ""

@export var ui_interaction_cousin: Control
@export var player_camera: Camera3D
@export var camera_vue_cousin: Camera3D
@export var player: CharacterBody3D
@export var ui_inventaire: Control

var active_secondary_camera: Camera3D = null
var camera_switched := false

func _ready():
	$Cousin/AnimationPlayer.play("IdleCousin")
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	ui_inventaire.visible = false

func _process(delta):
	# Affiche le prompt uniquement si joueur est dans la zone ET qu'aucune timeline n'est active
	ui_interaction_cousin.visible = player_in_area_cousin and current_timeline_name == ""

func _input(event):
	# Bloque interaction "E" si une timeline est en cours
	if current_timeline_name != "":
		return

	if event.is_action_pressed("e") and player_in_area_cousin:
		_switch_to_camera(camera_vue_cousin)
		_traductionMort()

func _traductionMort():
	_switch_to_camera(camera_vue_cousin)
	current_timeline_name = "CousinTraduction"
	if player and "lock_movement" in player:
		player.lock_movement(true)
	Dialogic.start_timeline(current_timeline_name)

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return

	cam.current = true
	camera_switched = true
	active_secondary_camera = cam

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

# Zones d’interaction
func _on_vue_cousin_body_entered(body):
	if body.is_in_group("player"):
		player_in_area_cousin = true
		print("dedans : ", body.name)

func _on_vue_cousin_body_exited(body):
	if body.is_in_group("player"):
		player_in_area_cousin = false
		print("sort : ", body.name)

# Callback quand la timeline se termine
func _on_dialogic_timeline_ended():
	print("Timeline terminée :", current_timeline_name)
	player.lock_movement(false)

	if current_timeline_name == "CousinTraduction":
		_switch_to_player_camera()

	current_timeline_name = ""
