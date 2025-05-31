extends Node3D

@export var player_camera: Camera3D
@export var player: Node3D  # Connecte le CharacterBody3D ici via l’inspecteur
@export var carton_pose: Node3D
@export var talisman: Node3D
@export var talisman_camera: Camera3D
@export var talisman_out_camera: Camera3D

var active_secondary_camera: Camera3D = null
var camera_switched := false

# Zones de déclenchement
var player_enter_objet := false
var player_enter_talisman := false
var player_enter_carton := false

func _ready():
	carton_pose.visible = false
	talisman.visible = false

func _process(delta):
	# Affiche le carton et le talisman
	if player_enter_carton and Input.is_action_just_pressed("e"):
		carton_pose.visible = true
		talisman.visible = true

	# Basculer vers la caméra du talisman
	if player_enter_talisman and Input.is_action_just_pressed("e") and not camera_switched:
		print("Switch vers caméra talisman")
		if talisman_camera:
			_switch_to_camera(talisman_camera)

	# Revenir à la caméra du joueur depuis le talisman
	elif player_enter_talisman and camera_switched and Input.is_action_just_pressed("ui_cancel"):
		print("Retour à la caméra talisman_out")
		_switch_to_camera(talisman_out_camera)

	# Switch vers caméra secondaire générique
	if Input.is_action_just_pressed("e") and player_enter_objet and not camera_switched:
		print("Switch vers caméra secondaire :", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

	# Retour caméra joueur depuis objet secondaire
	elif Input.is_action_just_pressed("ui_cancel") and player_enter_objet and camera_switched:
		print("Retour à la caméra joueur")
		_switch_to_player_camera()

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return

	active_secondary_camera = cam
	cam.current = true
	camera_switched = true

	# 🔒 ou 🔓 Bloquer ou débloquer les mouvements selon la caméra
	if cam == talisman_out_camera:
		if player and "lock_movement" in player:
			player.lock_movement(false)
	else:
		if player and "lock_movement" in player:
			player.lock_movement(true)
		else:
			print("Erreur : joueur non défini ou méthode lock_movement manquante.")

func _switch_to_player_camera():
	if active_secondary_camera:
		active_secondary_camera.current = false  # désactive la caméra secondaire

	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null

	# 🔓 Débloque le joueur
	if player and "lock_movement" in player:
		player.lock_movement(false)

func _dialogue_mere():
	Dialogic.start_timeline("FirstInteractionObjetTombe")

func get_active_camera() -> Camera3D:
	return active_secondary_camera if active_secondary_camera else player_camera

# Zone talisman
func _on_area_talisman_body_entered(body):
	if body.is_in_group("player"):
		player_enter_talisman = true

func _on_area_talisman_body_exited(body):
	if body.is_in_group("player"):
		player_enter_talisman = false

# Zone poser carton
func _on_carton_area_body_entered(body):
	if body.is_in_group("player"):
		player_enter_carton = true

func _on_carton_area_body_exited(body):
	if body.is_in_group("player"):
		player_enter_carton = false
