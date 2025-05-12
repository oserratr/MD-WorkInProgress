extends CharacterBody3D

@export var move_speed = 5.0
@export var acceleration = 10.0

var target_position: Vector3
var current_velocity = Vector3.ZERO

func _ready():
	target_position = global_transform.origin

func _process(delta):
	if target_position.distance_to(global_transform.origin) > 0.1:
		move_towards_target(delta)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_click()

func handle_click():
	var camera = get_viewport().get_camera_3d()
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var direction = camera.project_ray_normal(mouse_position)
	var space_state = get_world_3d().direct_space_state
	
	# Intersect Ray avec collision_mask
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = from + direction * 1000
	query.exclude = [self]
	query.collision_mask = 2  # Assure-toi que ton sol est sur le calque 1

	var result = space_state.intersect_ray(query)
	
	if result:
		target_position = result.position

func move_towards_target(delta):
	var direction = (target_position - global_transform.origin).normalized()
	current_velocity = direction * move_speed
	
	# Applique la vitesse au personnage
	velocity = current_velocity
	move_and_slide()
