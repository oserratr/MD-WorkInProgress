extends Node3D

@export var player_camera: Camera3D
@export var player: Node3D
@export var alo_camera: Camera3D
@export var alo_out_camera: Camera3D
@export var ui_interaction: Control
@export var ui_echap: Control

var active_secondary_camera: Camera3D = null
var camera_switched := false
var tv_inspecter := false

# Zone de déclenchement
var player_enter_alo := false

func _ready():
	ui_interaction.visible = false
	ui_echap.visible = false
	$"../InnervoiceTV".visible = false

func _process(delta):
	var is_on_alo_cam = is_instance_valid(alo_camera) and alo_camera.current

	if not is_on_alo_cam:
		ui_interaction.visible = player_enter_alo
	else:
		ui_interaction.visible = false

	ui_echap.visible = is_on_alo_cam

	if player_enter_alo and Input.is_action_just_pressed("e") and not camera_switched:
		print("Switch vers caméra alo")
		if is_instance_valid(alo_camera):
			_switch_to_camera(alo_camera)
			$"../InnervoiceTV".visible = true
			$"../InnervoiceTV/InnerVoice/AnimationPlayer".play("Fade_up")

	elif player_enter_alo and camera_switched and Input.is_action_just_pressed("ui_cancel"):
		print("Retour à la caméra alo_out")
		if is_instance_valid(alo_out_camera):
			_switch_to_camera(alo_out_camera)
			$"../InnervoiceTV".visible = false
			tv_inspecter = true

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return

	active_secondary_camera = cam
	cam.current = true
	camera_switched = true
	ui_interaction.visible = false

	if cam == alo_out_camera:
		if player and "lock_movement" in player:
			player.lock_movement(false)


		if is_instance_valid(alo_camera):
			alo_camera = null
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

func get_active_camera() -> Camera3D:
	return active_secondary_camera if active_secondary_camera else player_camera

# Zone alo

func _on_tv_body_entered(body):
	if body.is_in_group("player"):
		player_enter_alo = true

func _on_tv_body_exited(body):
	if body.is_in_group("player"):
		player_enter_alo = false
