extends CharacterBody3D

var gravity = 9.8
@export var speed = 2
@export var navigation_agent : NavigationAgent3D
@export var animation_player : AnimationPlayer
@export var stop_distance = 0.1

@export var game_manager = Node3D

func _process(delta):
	# Mise à jour de la caméra active depuis le GameManager
	var active_camera = game_manager.get_active_camera()
	
	# Gestion de la gravité
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Gestion du mouvement
	var new_velocity = movement()
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	
	move_and_slide()

	# Gestion des animations
	if navigation_agent.is_navigation_finished():
		animation_player.play("idle")
	else:
		animation_player.play("walking")
	
func _input(event):
	if Input.is_action_just_pressed("LeftMouse"):
		get_world_pos()
		
func get_world_pos() -> void:
	var active_camera = game_manager.get_active_camera()
	if active_camera == null:
		print("Erreur : Caméra active non définie")
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = active_camera.project_ray_origin(mouse_pos)
	var to = from + active_camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	
	var result = space.intersect_ray(ray_query)
	if result:
		navigation_agent.target_position = result.position
		look_at_path(result.position)
	
func movement() -> Vector3:
	if navigation_agent.is_navigation_finished():
		return Vector3.ZERO
	
	var next_path_position = navigation_agent.get_next_path_position()
	var current_agent_position = global_position
	
	# Calcul du vecteur de déplacement
	var new_velocity = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized() * speed
	
	return new_velocity
		
func look_at_path(direction : Vector3) -> void: 
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
