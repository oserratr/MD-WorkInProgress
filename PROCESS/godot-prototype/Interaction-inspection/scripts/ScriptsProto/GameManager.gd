extends Node3D

@export var player: CharacterBody3D
@export var interaction_area: Area3D
@export var uiButtonA: CanvasLayer
@export var uiButtonX: CanvasLayer
@export var uiButtonZoom: CanvasLayer
@export var uiButtonRotate: CanvasLayer
@export var uiButtonDeplacement: CanvasLayer
@export var carton_pickable: Node3D
@export var hand_player: MeshInstance3D

@export var seat_position: Vector3 = Vector3(0, 0, 0)
@export var stand_position: Vector3 = Vector3(0, 0, -1)

var showed_deplacement_hint := false
var movement_started := false
var movement_timer := 0.0

var x_button_timer: Timer
var waiting_first_interaction := true  # Devient false après la 1ère interaction
var playerAssis: bool = true
var can_interact: bool = false
var pending_state_change: bool = false
var next_position: Vector3
var in_mom_area: bool = false
var in_carton_area: bool = false
var carton_pris: bool = false

# Tutoriel guidé
enum TutorialStep { ROTATE, ZOOM, INTERACT }
var current_step: TutorialStep = TutorialStep.ROTATE
var tutorial_completed := false

func _ready():
	# Création d'un Timer pour uiButtonX
	x_button_timer = Timer.new()
	x_button_timer.wait_time = 1.0
	x_button_timer.one_shot = true
	x_button_timer.connect("timeout", _on_x_button_timer_timeout)
	add_child(x_button_timer)

	
func _on_x_button_timer_timeout():
	uiButtonX.visible = false


func _process(delta):
	if player == null:
		return

	handle_tutorial_inputs()
	handle_interaction()
	handle_player_state()
	_narrative_interaction()
	interaction_carton()
	handle_deplacement_ui(delta)  # ← Nouveau

	if pending_state_change and can_interact:
		player.global_position = next_position
		pending_state_change = false


func handle_tutorial_inputs():
	match current_step:
		TutorialStep.ROTATE:
			uiButtonRotate.visible = true
			uiButtonZoom.visible = false
			uiButtonA.visible = false

			var right_stick = abs(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
			if right_stick > 0.3:
				current_step = TutorialStep.ZOOM
				print("Étape rotation complétée")

		TutorialStep.ZOOM:
			uiButtonRotate.visible = false
			uiButtonZoom.visible = true
			uiButtonA.visible = false

			var trigger_left = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)
			var trigger_right = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT)
			if trigger_left > 0.3 or trigger_right > 0.3:
				current_step = TutorialStep.INTERACT
				tutorial_completed = true
				waiting_first_interaction = true
				print("Étape zoom complétée")

		TutorialStep.INTERACT:
			uiButtonZoom.visible = false
			if waiting_first_interaction:
				uiButtonA.visible = true
				
func handle_deplacement_ui(delta):
	if showed_deplacement_hint and not movement_started:
		var x = abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X))
		var y = abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
		var deadzone = 0.2
		if x > deadzone or y > deadzone:
			movement_started = true
			print("Mouvement détecté → démarrage du timer pour cacher l'UI")

	if movement_started:
		movement_timer += delta
		if movement_timer >= 1.0:
			uiButtonDeplacement.visible = false
			showed_deplacement_hint = false  # Ne pas recommencer


func handle_player_state():
	player.set_movement_enabled(not playerAssis)

func handle_interaction():
	if not can_interact or current_step != TutorialStep.INTERACT:
		return

	if playerAssis and Input.is_action_just_pressed("interaction"):
		playerAssis = false
		next_position = stand_position
		pending_state_change = true
		print("se lève")
		
		if waiting_first_interaction:
			waiting_first_interaction = false
			uiButtonA.visible = false
			uiButtonDeplacement.visible = true  # Affiche le bouton déplacement
			showed_deplacement_hint = true      # On active le suivi pour le cacher plus tard

	elif not playerAssis and Input.is_action_just_pressed("interaction"):
		playerAssis = true
		next_position = seat_position
		pending_state_change = true
		print("s'assoit")



func _narrative_interaction():
	if in_mom_area and Input.is_action_just_pressed("interaction"):
		Dialogic.start("greniertuto")
		uiButtonX.visible = true
		x_button_timer.start()  # ← Lance le timer de 0.5s



func interaction_carton():
	if Dialogic.VAR.joueur_interagit and in_carton_area:
		if Input.is_action_just_pressed("interaction"):
			print("prendre carton")
			carton_pickable.queue_free()

# --- Zones d'interaction ---

func _on_area_3d_body_entered(body):
	if body == player:
		can_interact = true
		if tutorial_completed and not waiting_first_interaction:
			uiButtonA.visible = true

func _on_area_3d_body_exited(body):
	if body == player:
		can_interact = false
		if tutorial_completed and not waiting_first_interaction:
			uiButtonA.visible = false

func _on_area_mom_body_entered(body):
	if body == player:
		in_mom_area = true
		if tutorial_completed and not waiting_first_interaction:
			uiButtonA.visible = true

func _on_area_mom_body_exited(body):
	if body == player:
		in_mom_area = false
		if tutorial_completed and not waiting_first_interaction:
			uiButtonA.visible = false

func _on_cartonprendre_body_entered(body):
	if body == player:
		in_carton_area = true
		if tutorial_completed and not waiting_first_interaction:
			uiButtonA.visible = true

func _on_cartonprendre_body_exited(body):
	if body == player:
		in_carton_area = false
		if tutorial_completed and not waiting_first_interaction:
			uiButtonA.visible = false
