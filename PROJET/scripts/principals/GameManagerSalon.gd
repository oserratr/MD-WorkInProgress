extends Node3D

@export var player_camera: Camera3D
@export var carton_pose: Node3D
@export var talisman: Node3D

var active_secondary_camera: Camera3D = null
var camera_switched := false

# Variables pour détecter les interactions
var player_enter_area := false
var player_enter_talisman := false
var mother := false
func _ready():
	carton_pose.visible = false
	talisman.visible = false
			
func _process(delta):
	# Afficher le carton et le talisman lorsque le joueur entre dans la zone
	if player_enter_area and Input.is_action_just_pressed("e"):
		carton_pose.visible = true
		talisman.visible = true
		mother = true
		_dialogue_mere()
		
	# Basculer vers la caméra du talisman
	if player_enter_talisman and Input.is_action_just_pressed("e") and not camera_switched:
		print("switch")
		var talisman_camera = _get_camera_from_node(talisman)
		if talisman_camera:
			_switch_to_camera(talisman_camera)
		
	# Revenir à la caméra du joueur
	elif player_enter_talisman and camera_switched and Input.is_action_just_pressed("ui_cancel"):
		_switch_to_player_camera()
	
	
	
		
func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return
	cam.current = true
	camera_switched = true
	active_secondary_camera = cam

func _switch_to_player_camera():
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null

# Retourne la caméra active (secondaire ou joueur)
func get_active_camera() -> Camera3D:
	if active_secondary_camera != null:
		return active_secondary_camera
	return player_camera

# Récupère la caméra enfant d'un Node3D, si elle existe
func _get_camera_from_node(node: Node3D) -> Camera3D:
	var cam = node.get_node_or_null("Camera3D")
	if cam == null:
		print("Erreur : Aucun Camera3D trouvé dans le noeud spécifié.")
	return cam
func _dialogue_mere():
	Dialogic.start_timeline("FirstInteractionObjetTombe")
	
# Gestion des signaux de zone
func _on_carton_area_body_entered(body):
	if body.is_in_group("player"):
		player_enter_area = true

func _on_carton_area_body_exited(body):
	if body.is_in_group("player"):
		player_enter_area = false

func _on_area_talisman_body_entered(body):
	if body.is_in_group("player"):
		player_enter_talisman = true

func _on_area_talisman_body_exited(body):
	if body.is_in_group("player"):
		player_enter_talisman = false
