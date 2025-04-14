extends Node3D

@export var player: CharacterBody3D
@export var interaction_area: Area3D
@export var uiButtonA: CanvasLayer

# Positions personnalisables pour assis/debout
@export var seat_position: Vector3 = Vector3(0, 0, 0)
@export var stand_position: Vector3 = Vector3(0, 0, -1)

var playerAssis: bool = true
var can_interact: bool = false

func _process(delta):
	if player == null:
		return

	handle_interaction()
	handle_player_state()

func handle_player_state():
	if playerAssis:
		player.set_movement_enabled(false)
	else:
		player.set_movement_enabled(true)

func handle_interaction():
	if not can_interact:
		return

	if playerAssis:
		# Le joueur est assis
		if Input.is_action_just_pressed("interaction"):
			playerAssis = false
			# Edit position player (debout)
			player.global_position = stand_position
			print("se leve")
	else:
		# Le joueur est debout
		if Input.is_action_just_pressed("interaction"):
			playerAssis = true
			# Edit position player (assis)
			player.global_position = seat_position
			print("s'assoie")

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
