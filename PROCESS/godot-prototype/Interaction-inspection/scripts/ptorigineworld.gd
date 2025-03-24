extends Node3D

@export var rotation_speed: float = 100.0  # Vitesse de rotation (degrés par seconde)
var rotation_velocity: float = 0.0  # Vitesse actuelle de rotation
var damping: float = 5.0  # Facteur de ralentissement

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			rotation_velocity = -rotation_speed  # Scroll vers le haut → Rotation négative
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			rotation_velocity = rotation_speed  # Scroll vers le bas → Rotation positive

func _process(delta):
	# Appliquer la rotation avec interpolation pour la fluidité
	rotation.y += deg_to_rad(rotation_velocity * delta)
	
	# Appliquer un ralentissement progressif
	rotation_velocity = lerp(rotation_velocity, 0.0, damping * delta)
