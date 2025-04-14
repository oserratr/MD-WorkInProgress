extends Node3D

@export var player: CharacterBody3D
@export var interaction_area: Area3D  # ← L’Area où le joueur peut interagir

var playerAssis: bool = true
var can_interact: bool = false

func _ready():
	if interaction_area:
		interaction_area.body_entered.connect(_on_area_entered)
		interaction_area.body_exited.connect(_on_area_exited)

func _process(delta):
	if player == null:
		return

	handle_player_state()

func handle_player_state():
	if playerAssis:
		player.set_movement_enabled(false)
	else:
		player.set_movement_enabled(true)

func handle_interaction():
	if can_interact and Input.is_joy_button_pressed(0, JOY_BUTTON_A):  # A = 0
		playerAssis = !playerAssis

func _on_area_entered(body):
	if body == player:
		can_interact = true

func _on_area_exited(body):
	if body == player:
		can_interact = false
