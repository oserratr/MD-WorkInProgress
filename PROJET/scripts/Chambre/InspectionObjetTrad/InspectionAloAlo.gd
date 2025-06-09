extends Node3D

@export var trigger_camera: Camera3D  # assignée dans l'inspecteur
@export var suz: Node3D

var default_transform: Transform3D
var default_suz_rotation: Vector3

const ROTATION_SPEED := 0.3  # Vitesse de rotation ajustable
var is_rotating := false
var last_mouse_position: Vector2

func _ready():
	default_transform = global_transform
	default_suz_rotation = suz.rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	# ✅ Interagir uniquement si trigger_camera est la caméra active
	if not trigger_camera.current:
		return

	# Début de la rotation sur clic gauche
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_rotating = event.pressed
		last_mouse_position = event.position

	# Réinitialisation avec le clic droit
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		reset_camera()

	# Rotation de la caméra
	if event is InputEventMouseMotion and is_rotating:
		var mouse_delta = event.relative
		rotate_camera(mouse_delta)

func rotate_camera(mouse_delta: Vector2):
	# Appliquer la rotation à la caméra et à l'objet "suz"
	rotation.x -= mouse_delta.y * ROTATION_SPEED * 0.01
	suz.rotation.y -= mouse_delta.x * ROTATION_SPEED * 0.01
	rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))

func reset_camera():
	global_transform = default_transform
	suz.rotation = default_suz_rotation
