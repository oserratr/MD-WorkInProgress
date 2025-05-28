extends Node3D

@export var player_camera = Camera3D
@export var ui_interaction = Control
@export var ui_interaction_echap = Control
@export var player: Node3D  # Connecte le CharacterBody3D ici via l’inspecteur

var active_secondary_camera: Camera3D = null
var camera_switched := false
var player_enter_objet := false

func _process(delta):
	# Affichage UI "E"
	ui_interaction.visible = player_enter_objet and not camera_switched

	# Affichage UI "Échap"
	ui_interaction_echap.visible = player_enter_objet and camera_switched

	# Switch vers caméra secondaire
	if Input.is_action_just_pressed("e") and player_enter_objet and not camera_switched:
		print("Switching to secondary camera:", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

	# Retour caméra joueur
	elif Input.is_action_just_pressed("ui_cancel") and player_enter_objet and camera_switched:
		print("Switching back to player camera")
		_switch_to_player_camera()

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return
	
	cam.current = true
	camera_switched = true
	ui_interaction.visible = false

	# 🔒 Bloque le joueur
	if player and "lock_movement" in player:
		player.lock_movement(true)
	else:
		print("Erreur : joueur non défini ou méthode lock_movement manquante.")

func _switch_to_player_camera():
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null
	ui_interaction.visible = false
	ui_interaction_echap.visible = false

	# 🔓 Débloque le joueur
	if player and "lock_movement" in player:
		player.lock_movement(false)

func get_active_camera() -> Camera3D:
	return active_secondary_camera if active_secondary_camera else player_camera

# Zone tableau 1
func _on_tableau_1_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_tableau_1_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false

# Zone tableau 2
func _on_tableau_2_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_tableau_2_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false

# Zone tableau 3
func _on_tableau_3_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_tableau_3_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false
