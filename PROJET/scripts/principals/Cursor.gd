extends Sprite2D

@export var mouse_sens = 800.0
@export var cursor_texture : Texture2D  # Texture personnalisée pour le curseur

func _ready() -> void:
	# Cache le curseur système et confine le mouvement de la souris
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Applique la texture personnalisée si définie
	if cursor_texture:
		texture = cursor_texture
	
	# Centre le curseur au démarrage
	position = get_viewport().get_visible_rect().size / 2

func _process(delta: float) -> void:
	# Déplacement avec le stick gauche
	var direction = Vector2(
		Input.get_action_strength("ls_right") - Input.get_action_strength("ls_left"),
		Input.get_action_strength("ls_down") - Input.get_action_strength("ls_up")
	)
	
	if direction.length() > 0:
		# Normalise pour éviter des déplacements plus rapides en diagonale
		if abs(direction.x) == 1 and abs(direction.y) == 1:
			direction = direction.normalized()
		
		# Calcul du mouvement
		var movement = mouse_sens * direction * delta
		var new_position = position + movement
		
		# Empêche le curseur de sortir de l'écran
		var screen_size = get_viewport().get_visible_rect().size
		new_position.x = clamp(new_position.x, 0, screen_size.x)
		new_position.y = clamp(new_position.y, 0, screen_size.y)
		
		position = new_position
	
func _input(event: InputEvent) -> void:
	# Simulation d'un clic avec le bouton A
	if event is InputEventJoypadButton and event.device == 0 and \
		event.button_index == JOY_BUTTON_A and event.pressed:
		
		var joy_click = InputEventMouseButton.new()
		joy_click.button_index = MOUSE_BUTTON_LEFT
		joy_click.position = position
		joy_click.pressed = true
		Input.parse_input_event(joy_click)
