extends Node3D

@export var trigger_camera: Camera3D  # assignée dans l'inspecteur
@export var suz : Node3D

var default_transform: Transform3D
var default_suz_rotation: Vector3

const ROTATION_SPEED := 2.5  # Vitesse de rotation ajustable

func _ready():
	default_transform = global_transform
	default_suz_rotation = suz.rotation

func _physics_process(delta: float) -> void:
	if not trigger_camera.current:
		return

	# Lire les axes du joystick droit (Right Stick)
	var rs_x := Input.get_action_strength("ui_right_stick_right") - Input.get_action_strength("ui_right_stick_left")
	var rs_y := Input.get_action_strength("ui_right_stick_down") - Input.get_action_strength("ui_right_stick_up")

	# Appliquer la rotation en fonction du stick droit
	if abs(rs_x) > 0.05 or abs(rs_y) > 0.05:
		rotation.x += -rs_y * ROTATION_SPEED * delta
		suz.rotation.y += rs_x * ROTATION_SPEED * delta

	# Réinitialisation avec la touche "cancel"
	if Input.is_action_just_pressed("cancel"):
		global_transform = default_transform
		suz.rotation = default_suz_rotation
