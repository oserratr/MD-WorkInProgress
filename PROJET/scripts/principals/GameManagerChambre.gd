extends Node3D

@export var player_camera = Camera3D

var active_secondary_camera: Camera3D = null
var camera_switched := false

# Variable signal detecter
var player_enter_area_lit := false
var player_enter_area_gauche := false

#func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	# Activer la caméra secondaire si elle est définie et pas encore active
	if active_secondary_camera and not camera_switched:
		print("Switching to secondary camera:", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

	# Retour à la caméra du joueur si aucune caméra secondaire n'est active
	elif not player_enter_area_lit and not player_enter_area_gauche and camera_switched:
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
func _on_vue_lit_face_body_entered(body):
		if body.is_in_group("player"):
			player_enter_area_lit = true
	
func _on_vue_lit_face_body_exited(body):
	if body.is_in_group("player"):
			player_enter_area_lit = false
	
func _on_vue_cote_gauche_chambre_body_entered(body):
	if body.is_in_group("player"):
			player_enter_area_gauche = true

func _on_vue_cote_gauche_chambre_body_exited(body):
	if body.is_in_group("player"):
			player_enter_area_gauche = false
	
	
func get_active_camera() -> Camera3D:
	if active_secondary_camera != null:
		return active_secondary_camera
	return player_camera


