extends Node3D

@export var player_camera = Camera3D
@export var ui_interaction = Control
@export var ui_interaction_echap = Control
var active_secondary_camera: Camera3D = null
var camera_switched := false

# Variable signal detecter
var player_enter_objet := false

func _process(delta):
	# Affichage de l'UI d'interaction "E"
	if player_enter_objet and not camera_switched:
		print("afficher")
		ui_interaction.visible = true
	else:
		ui_interaction.visible = false
	
	# Affichage de l'UI d'interaction "Echap"
	if camera_switched and player_enter_objet:
		ui_interaction_echap.visible = true
	else:
		ui_interaction_echap.visible = false
	
	# Activer la caméra secondaire si elle est définie et pas encore active
	if Input.is_action_just_pressed("e") and player_enter_objet and not camera_switched:
		print("Switching to secondary camera:", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

	# Retour à la caméra du joueur si aucune caméra secondaire n'est active
	elif Input.is_action_just_pressed("ui_cancel") and player_enter_objet and camera_switched:
		print("Switching back to player camera")
		_switch_to_player_camera()

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return
	cam.current = true
	camera_switched = true
	ui_interaction.visible = false  # Masque l'UI quand tu changes de caméra
	
	# Bloque le mouvement du personnage
	var player = get_node("/root/Grenier/Player")
	player.lock_movement(true)

func _switch_to_player_camera():
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null
	ui_interaction.visible = false  # Masque aussi l'UI quand tu reviens à la caméra du joueur
	ui_interaction_echap.visible = false  # Masque aussi l'UI echap

	# Débloque le mouvement du personnage
	var player = get_node("/root/Grenier/Player")
	player.lock_movement(false)

		
func get_active_camera() -> Camera3D:
	if active_secondary_camera != null:
		return active_secondary_camera
	return player_camera

func _on_tableau_1_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_tableau_1_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false

func _on_tableau_2_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_tableau_2_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false


func _on_tableau_3_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_tableau_3_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false
