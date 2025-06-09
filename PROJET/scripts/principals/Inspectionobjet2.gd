extends Node3D

@export var player_camera: Camera3D
@export var ui_interaction: Control
@export var ui_interaction_echap: Control
@export var player: Node3D  # Connecte le CharacterBody3D ici via l’inspecteur
@export var zoomphotogp: Sprite2D

var active_secondary_camera: Camera3D = null
var camera_switched := false
var player_enter_objet := false
var player_enter_objet_gp := false
var player_enter_objet_alo := false

func _ready():
	ui_interaction.visible = false
	ui_interaction_echap.visible = false
	zoomphotogp.visible = false
	$"../Zoomphotogp/ui_interaction_echap".visible = false

func _process(delta):
	# Affichage de l'UI E pour les deux objets
	ui_interaction.visible = player_enter_objet or player_enter_objet_gp

	# Interaction avec le tiroir
	if player_enter_objet:
		if Input.is_action_just_pressed("e") and not camera_switched:
			get_tree().change_scene_to_file("res://scenes/InteractionObjets/tiroir_1_interaction.tscn")

	# Interaction avec la photo grand-père
	elif player_enter_objet_gp:
		if Input.is_action_just_pressed("e") and not camera_switched:
			zoomphotogp.visible = true 
			$"../Zoomphotogp/ui_interaction_echap".visible = true
			player.lock_movement(true)

	# Retour caméra joueur avec Échap si caméra switchée
	elif Input.is_action_just_pressed("ui_cancel") and player_enter_objet and player_enter_objet_gp and camera_switched:
		print("Switching back to player camera")
		_switch_to_player_camera()

func _unhandled_input(event):
	# Gestion d’Échap pour quitter le zoom photo GP
	if event.is_action_pressed("ui_cancel") and player_enter_objet_gp:
		zoomphotogp.visible = false 
		$"../Zoomphotogp/ui_interaction_echap".visible = false
		player.lock_movement(false)

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

# Zone tiroir lettre
func _on_vue_tiroir_lettre_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet = true

func _on_vue_tiroir_lettre_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet = false

# Zone photo grand-père
func _on_photo_gp_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet_gp = true

func _on_photo_gp_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet_gp = false


func _on_aloalo_body_entered(body):
	if body.is_in_group("player"):
		player_enter_objet_alo = true


func _on_aloalo_body_exited(body):
	if body.is_in_group("player"):
		player_enter_objet_alo = false
