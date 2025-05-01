extends Node3D

@export var rotation_speed := 100.0
var rotation_velocity := 0.0
var damping := 5.0

func _physics_process(delta):
	var right_stick_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var deadzone = 0.2
	if abs(right_stick_x) < deadzone:
		right_stick_x = 0

	# Calculer la vitesse de rotation
	rotation_velocity = rotation_speed * right_stick_x

	# Appliquer la rotation fluide sur Y
	rotation.y += deg_to_rad(rotation_velocity * delta)

	# Diminuer progressivement la vitesse de rotation
	rotation_velocity = lerp(rotation_velocity, 0.0, damping * delta)
