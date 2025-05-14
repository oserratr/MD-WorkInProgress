extends Node3D

@export var player_camera = Camera3D

var active_secondary_camera: Camera3D = null
var camera_switched := false

# Variable signal detecter
var player_enter_area1 := false
var player_enter_area2 := false
var player_enter_objet := false

func _process(delta):
	# Activer la caméra secondaire si elle est définie et pas encore active
	if active_secondary_camera and not camera_switched:
		print("Switching to secondary camera:", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

	# Retour à la caméra du joueur si aucune caméra secondaire n'est active
	elif not player_enter_area1 and not player_enter_area2 and camera_switched:
		print("Switching back to player camera")
		_switch_to_player_camera()
		
	
		
func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return
	cam.current = true
	camera_switched = true

func _switch_to_player_camera():
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null

# Signaux connectés
func _on_vue_mere_body_entered(body):
	if body.is_in_group("player"):
		player_enter_area1 = true


func _on_vue_mere_body_exited(body):
	if body.is_in_group("player"):
		player_enter_area1 = false

func _on_vue_porte_body_entered(body):
	if body.is_in_group("player"):
		player_enter_area2 = true

func _on_vue_porte_body_exited(body):
	if body.is_in_group("player"):
		player_enter_area2 = false
		
func get_active_camera() -> Camera3D:
	if active_secondary_camera != null:
		return active_secondary_camera
	return player_camera
