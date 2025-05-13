extends Sprite2D

@export var mouse_sens = 800.0
@export var cursor_texture : Texture2D

var cursor_position : Vector2

func _ready() -> void:
	# Cache le curseur système
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Applique la texture personnalisée si définie
	if cursor_texture:
		texture = cursor_texture

	# Centre le curseur au démarrage
	cursor_position = get_viewport().size / 2
	global_position = cursor_position


func _process(delta: float) -> void:
	# Récupère les dimensions de l'écran
	var screen_size = get_viewport().size
	
	# Déplacement avec le stick gauche
	var direction = Vector2(
		Input.get_action_strength("ls_right") - Input.get_action_strength("ls_left"),
		Input.get_action_strength("ls_down") - Input.get_action_strength("ls_up")
	)
	
	if direction.length() > 0:
		# Normalise pour des mouvements cohérents
		direction = direction.normalized()
		cursor_position += direction * mouse_sens * delta
		
		# Empêche le curseur de sortir de l'écran
		cursor_position.x = clamp(cursor_position.x, 0, screen_size.x)
		cursor_position.y = clamp(cursor_position.y, 0, screen_size.y)

	# Met à jour la position globale
	global_position = cursor_position


func _unhandled_input(event: InputEvent) -> void:
	# Simulation d'un clic avec le bouton A
	if event is InputEventJoypadButton and event.device == 0 and event.button_index == JOY_BUTTON_A:
		if event.pressed:
			# Envoie un clic gauche
			var joy_click = InputEventMouseButton.new()
			joy_click.button_index = MOUSE_BUTTON_LEFT
			joy_click.position = cursor_position
			joy_click.pressed = true
			Input.parse_input_event(joy_click)

		else:
			# Envoie un relâchement du clic
			var joy_release = InputEventMouseButton.new()
			joy_release.button_index = MOUSE_BUTTON_LEFT
			joy_release.position = cursor_position
			joy_release.pressed = false
			Input.parse_input_event(joy_release)
