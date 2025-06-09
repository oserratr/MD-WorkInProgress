extends Node3D

@export var player_camera: Camera3D
@export var player: Node3D
@export var carton_pose: Node3D
@export var talisman: Node3D
@export var talisman_camera: Camera3D
@export var talisman_out_camera: Camera3D
@export var ui_interaction: Control
@export var ui_echap: Control
@export var mere: Node3D  # ✅ Ajout : référence à l'objet "Mere"

var active_secondary_camera: Camera3D = null
var camera_switched := false
var carton_drop := false

# Zones de déclenchement
var player_enter_objet := false
var player_enter_talisman := false
var player_enter_carton := false

func _ready():
	carton_pose.visible = false
	if is_instance_valid(talisman):
		talisman.visible = false
	ui_interaction.visible = false
	ui_echap.visible = false

func _process(delta):
	var is_on_talisman_cam = is_instance_valid(talisman_camera) and talisman_camera.current

	if not is_on_talisman_cam:
		if not carton_pose.visible and (not is_instance_valid(talisman) or not talisman.visible):
			ui_interaction.visible = player_enter_carton
		elif carton_pose.visible and is_instance_valid(talisman) and talisman.visible:
			ui_interaction.visible = player_enter_talisman
		else:
			ui_interaction.visible = false
	else:
		ui_interaction.visible = false

	ui_echap.visible = is_on_talisman_cam

	if player_enter_carton and Input.is_action_just_pressed("e"):
		carton_pose.visible = true
		var my_music = preload("res://assets/Son/lettre.mp3")
		AudioManager.play_music(my_music)
		carton_drop = true
		if is_instance_valid(talisman):
			talisman.visible = true

	if player_enter_talisman and Input.is_action_just_pressed("e") and not camera_switched:
		print("Switch vers caméra talisman")
		if is_instance_valid(talisman_camera):
			_switch_to_camera(talisman_camera)

	elif player_enter_talisman and camera_switched and Input.is_action_just_pressed("ui_cancel"):
		print("Retour à la caméra talisman_out")
		if is_instance_valid(talisman_out_camera):
			_switch_to_camera(talisman_out_camera)

	if Input.is_action_just_pressed("e") and player_enter_objet and not camera_switched:
		print("Switch vers caméra secondaire :", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

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

	if cam == talisman_out_camera:
		if player and "lock_movement" in player:
			player.lock_movement(false)

		if is_instance_valid(talisman):
			talisman.queue_free()
			talisman = null

		if is_instance_valid(talisman_camera):
			talisman_camera = null

		# ✅ Déplacement de l'objet "Mere"
		if is_instance_valid(mere):
			mere.global_position = Vector3(-1.726, -0.024, 2.348)  # ← AJUSTE CETTE POSITION
	else:
		if player and "lock_movement" in player:
			player.lock_movement(true)
		else:
			print("Erreur : joueur non défini ou méthode lock_movement manquante.")

func _switch_to_player_camera():
	if active_secondary_camera:
		active_secondary_camera.current = false

	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null

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

func get_bool_carton_drop() -> bool:
	return carton_drop
