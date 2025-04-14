extends CharacterBody3D

const SPEED = 5.0

@onready var pivot = $CameraOrigin            # <- point de focus du zoom
@onready var camera = $CameraOrigin/CameraPlayer

@export var sens := 0.5
@export var rotation_speed := 100.0
@export var zoom_speed := 5.0
@export_range(1.0, 10.0, 0.1) var min_zoom := 2.0   # ← slider dans l’inspecteur
@export_range(1.0, 20.0, 0.1) var max_zoom := 10.0  # ← slider dans l’inspecteur

var rotation_velocity := 0.0
var zoom_velocity := 0.0
var damping := 5.0
var camera_distance := 5.0  # Distance initiale

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_distance = clamp(camera_distance, min_zoom, max_zoom)
	_update_camera_distance()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# --- Rotation (stick droit) ---
	var right_stick_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var deadzone = 0.2
	if abs(right_stick_x) < deadzone:
		right_stick_x = 0
	rotation_velocity = rotation_speed * right_stick_x
	rotation.y += deg_to_rad(rotation_velocity * delta)
	rotation_velocity = lerp(rotation_velocity, 0.0, damping * delta)

	# --- Zoom (gâchettes) ---
	var trigger_left = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)
	var trigger_right = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT)
	var trigger_deadzone = 0.1

	if trigger_left > trigger_deadzone:
		zoom_velocity = -zoom_speed * trigger_left
	elif trigger_right > trigger_deadzone:
		zoom_velocity = zoom_speed * trigger_right

	# Appliquer le zoom et le limiter
	camera_distance = clamp(camera_distance + zoom_velocity * delta, min_zoom, max_zoom)
	zoom_velocity = lerp(zoom_velocity, 0.0, damping * delta)

	_update_camera_distance()

	# --- Déplacement (stick gauche) ---
	var left_stick_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var left_stick_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	if abs(left_stick_x) < deadzone:
		left_stick_x = 0
	if abs(left_stick_y) < deadzone:
		left_stick_y = 0

	var input_dir = Vector2(left_stick_x, left_stick_y)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _update_camera_distance():
	# Direction de pivot vers la caméra
	var direction = (camera.global_position - pivot.global_position).normalized()

	# Sécurité : on clamp la distance à chaque update
	camera_distance = clamp(camera_distance, min_zoom, max_zoom)

	# Nouvelle position de la caméra en fonction de la distance
	camera.global_position = pivot.global_position + direction * camera_distance
