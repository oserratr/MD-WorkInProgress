extends Node3D

@export var player_camera: Camera3D
@export var carton_pose: Node3D
@export var talisman: Node3D
@export var playerposition: CharacterBody3D


var active_secondary_camera: Camera3D = null
var camera_switched := false

# Variables pour détecter les interactions
var player_enter_talisman := false
var player_enter_area_carton := false
var player_enter_area_manger := false

func _ready():

	# Modifier la position en fonction de la scène précédente
	match GlobalSceneState.previous_scene_name:
		"Grenier", "GrenierApcarton":
			playerposition.global_transform.origin = Vector3(-3.252, 0.476, 1.479)
			playerposition.rotation = Vector3(0, deg_to_rad(-95.4), 0)
			print("desend du grenier")

		"Chambrebis","chambre":
			playerposition.global_transform.origin = Vector3(2.198, 0.476, 2.595)
			playerposition.rotation = Vector3(0, deg_to_rad(69.6), 0)
			print("desend de la chambre")
		_:
			print("Aucune position définie pour la scène précédente :", GlobalSceneState.previous_scene_name)

			
func _process(delta):

	# Basculer vers la camera vue carton
	if active_secondary_camera and not camera_switched:
		print("Switching to secondary camera:", active_secondary_camera)
		_switch_to_camera(active_secondary_camera)

	# Retour à la caméra du joueur si aucune caméra secondaire n'est active
	elif not player_enter_area_carton and not player_enter_area_manger and camera_switched:
		print("Switching back to player camera")
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
	

	
# Gestion des signaux de zone
		
func _on_vue_porte_grenier_body_entered(body):
	if body.is_in_group("player"):
		player_enter_area_carton = true

func _on_vue_porte_grenier_body_exited(body):
	if body.is_in_group("player"):
		player_enter_area_carton = false


func _on_vue_salle_manger_body_entered(body):
	if body.is_in_group("player"):
		player_enter_area_manger = true


func _on_vue_salle_manger_body_exited(body):
	if body.is_in_group("player"):
		player_enter_area_manger = false
