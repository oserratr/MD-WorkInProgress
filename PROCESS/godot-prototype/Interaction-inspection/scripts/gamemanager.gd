extends Node3D

@onready var ui = $uiinteraction
@onready var player_camera = $player/CameraOrigin/Camera3Dplayer

var active_secondary_camera: Camera3D = null
var camera_switched := false

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		print("UI visible, camera =", active_secondary_camera)
		ui.visible = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		ui.visible = false
		# Optionnel : reset si le joueur quitte la zone
		# _switch_to_player_camera()

func _process(delta):
	if ui.visible and Input.is_action_just_pressed("interaction"):
		print("Pressed interaction, cam:", active_secondary_camera)
	
	if ui.visible and Input.is_action_just_pressed("interaction") and active_secondary_camera and not camera_switched:
		print("Switching to secondary camera")
		_switch_to_camera(active_secondary_camera)

	elif ui.visible and Input.is_action_just_pressed("interaction") and camera_switched:
		print("Switching back to player camera")
		_switch_to_player_camera()

	# Nouveau : appuyer sur Échap revient à la caméra du joueur
	if camera_switched and Input.is_action_just_pressed("cancel"):  # "ui_cancel" est mappé à Échap par défaut
		print("Escape pressed: switching back to player camera")
		_switch_to_player_camera()

func _switch_to_camera(cam: Camera3D):
	cam.current = true
	print("Set", cam.name, "as current")
	camera_switched = true
	ui.visible = false
	
func _switch_to_player_camera():
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null


func _on_area_3d_2_body_entered(body):
	if body.is_in_group("player"):
		print("UI visible, camera =", active_secondary_camera)
		ui.visible = true


func _on_area_3d_2_body_exited(body):
	if body.is_in_group("player"):
		ui.visible = false
		# Optionnel : reset si le joueur quitte la zone
		# _switch_to_player_camera()
