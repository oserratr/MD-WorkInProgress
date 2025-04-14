extends Node3D

@export var player: CharacterBody3D
@export var interaction_area: Area3D
@export var uiButtonA: CanvasLayer

@export var seat_position: Vector3 = Vector3(0, 0, 0)
@export var stand_position: Vector3 = Vector3(0, 0, -1)

var playerAssis: bool = true
var can_interact: bool = false
var pending_state_change: bool = false  # Flag pour attendre l'entrée dans interaction_area
var next_position: Vector3  # La position à appliquer une fois dans la bonne zone
var in_mom_area: bool = false  # ← Nouveau flag


func _ready():
	if uiButtonA:
		uiButtonA.visible = false

func _process(delta):
	if player == null:
		return

	handle_interaction()
	handle_player_state()
	_narrative_interaction()


	if pending_state_change and can_interact:
		player.global_position = next_position
		pending_state_change = false

func handle_player_state():
	if playerAssis:
		player.set_movement_enabled(false)
	else:
		player.set_movement_enabled(true)

func handle_interaction():
	if not can_interact:
		return

	if playerAssis:
		if Input.is_action_just_pressed("interaction"):
			playerAssis = false
			next_position = stand_position
			pending_state_change = true
			print("se leve")
	else:
		if Input.is_action_just_pressed("interaction"):
			playerAssis = true
			next_position = seat_position
			pending_state_change = true
			print("s'assoie")

func _narrative_interaction():
	if in_mom_area and Input.is_action_just_pressed("interaction"):
		Dialogic.start("greniertuto")
	
	
func _on_area_3d_body_entered(body):
	if body == player:
		can_interact = true
		if uiButtonA:
			uiButtonA.visible = true

func _on_area_3d_body_exited(body):
	if body == player:
		can_interact = false
		if uiButtonA:
			uiButtonA.visible = false


func _on_area_mom_body_entered(body):
	if body == player:
		in_mom_area = true
		if uiButtonA:
			uiButtonA.visible = true
	


func _on_area_mom_body_exited(body):
	if body == player:
		in_mom_area = false
		if uiButtonA:
			uiButtonA.visible = false
