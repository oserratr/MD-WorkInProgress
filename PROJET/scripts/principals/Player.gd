extends CharacterBody3D

var gravity = 9.8
@export var speed = 2
@export var camera : Camera3D
@export var navigation_agent : NavigationAgent3D


func _process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var new_velocity = movement()
	
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	
	move_and_slide();
	
func _input(event):
	if Input.is_action_just_pressed("LeftMouse"):
		get_world_pos();

func get_world_pos() -> void :
	var mouse_pos = get_viewport().get_mouse_position();
	var ray_lenght = 100;
	var from = camera.project_ray_origin(mouse_pos);
	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght;
	var space = get_world_3d().direct_space_state;
	var ray_query = PhysicsRayQueryParameters3D.new();
	ray_query.from = from;
	ray_query.to = to;
	
	var result = space.intersect_ray(ray_query)
	
	navigation_agent.target_position = result.position;
	
	look_at_path(result.position)
	
func movement() -> Vector3:
	var next_path_position = navigation_agent.get_next_path_position()
	var current_agent_position = global_position
	
	var new_velocity = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized() * speed
	
	return new_velocity
		

func look_at_path(direction : Vector3) -> void: 
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
