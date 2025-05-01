extends CharacterBody3D

const SPEED = 3.0

@export var sens := 0.5
@export var zoom_speed := 5.0
@export_range(1.0, 10.0, 0.1) var min_zoom := 2.0
@export_range(1.0, 20.0, 0.1) var max_zoom := 10.0
@onready var camera = $"../CameraOrigin/CameraPlayer"  # remplace par le bon chemin si besoin

var zoom_velocity := 0.0
var damping := 5.0
var camera_distance := 5.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var can_move: bool = true

func set_movement_enabled(enabled: bool) -> void:
	can_move = enabled

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_distance = clamp(camera_distance, min_zoom, max_zoom)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# --- Zoom (gâchettes) ---
	var trigger_left = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)
	var trigger_right = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT)
	var trigger_deadzone = 0.1

	if trigger_left > trigger_deadzone:
		zoom_velocity = -zoom_speed * trigger_left
	elif trigger_right > trigger_deadzone:
		zoom_velocity = zoom_speed * trigger_right

	camera_distance = clamp(camera_distance + zoom_velocity * delta, min_zoom, max_zoom)
	zoom_velocity = lerp(zoom_velocity, 0.0, damping * delta)

	# --- Déplacement (stick gauche), seulement si autorisé ---
	var deadzone = 0.2
	var left_stick_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var left_stick_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	if abs(left_stick_x) < deadzone:
		left_stick_x = 0
	if abs(left_stick_y) < deadzone:
		left_stick_y = 0

	if can_move:
		var input_dir = Vector2(left_stick_x, left_stick_y)
		if input_dir.length() > 0.1:
			var cam_basis = camera.global_transform.basis
			var cam_forward = cam_basis.z
			var cam_right = cam_basis.x

			cam_forward.y = 0
			cam_right.y = 0
			cam_forward = cam_forward.normalized()
			cam_right = cam_right.normalized()

			var move_dir = (cam_forward * input_dir.y + cam_right * input_dir.x).normalized()

			# Appliquer la direction au mouvement
			velocity.x = move_dir.x * SPEED
			velocity.z = move_dir.z * SPEED

			# --- Rotation fluide du personnage vers la direction de déplacement ---
			var target_rotation = atan2(-move_dir.x, -move_dir.z)
			var current_rotation = rotation.y
			var new_rotation = lerp_angle(current_rotation, target_rotation, delta * 10.0)
			rotation.y = new_rotation
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
