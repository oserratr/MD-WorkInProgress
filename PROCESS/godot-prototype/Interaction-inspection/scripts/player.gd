extends CharacterBody3D

const SPEED = 5.0
@onready var pivot = $CameraOrigin
@export var sens = 0.5
@export var rotation_speed: float = 100.0  # Vitesse de rotation (degrés par seconde)
var rotation_velocity: float = 0.0  # Vitesse actuelle de rotation
var damping: float = 5.0  # Facteur de ralentissement

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready(): 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Gravité
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Lecture des gâchettes de la manette
	var trigger_left = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)   # LT
	var trigger_right = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT) # RT

	# Seuil pour éviter les micro-activations
	var trigger_deadzone = 0.1
	if trigger_left > trigger_deadzone:
		rotation_velocity = -rotation_speed * trigger_left  # Rotation vers la gauche
	elif trigger_right > trigger_deadzone:
		rotation_velocity = rotation_speed * trigger_right  # Rotation vers la droite

	# Appliquer la rotation avec interpolation pour la fluidité
	rotation.y += deg_to_rad(rotation_velocity * delta)
	rotation_velocity = lerp(rotation_velocity, 0.0, damping * delta)

	# Lecture du stick gauche de la manette (joystick analogique)
	var left_stick_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var left_stick_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)

	# Zone morte pour éviter les mouvements parasites
	var deadzone = 0.2
	if abs(left_stick_x) < deadzone:
		left_stick_x = 0
	if abs(left_stick_y) < deadzone:
		left_stick_y = 0

	# Calcul de la direction
	var input_dir = Vector2(left_stick_x, left_stick_y)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# (Optionnel) Tu peux supprimer cette fonction si tu n'utilises plus la souris
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			rotation_velocity = -rotation_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			rotation_velocity = rotation_speed

func _on_collision_shape_3d_tree_entered():
	pass # Replace with function body.

func _on_area_3d_body_entered(body):
	pass # Replace with function body.
