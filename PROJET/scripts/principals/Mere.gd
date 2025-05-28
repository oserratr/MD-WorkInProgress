extends Node3D

var player_in_area = false
var first_interaction = true
var interaction_with_carton = false
var interaction_without_carton = false

@export var interaction_carton: Node3D
@export var ui_interaction_mere: Control
@export var player: CharacterBody3D  # à connecter au CharacterBody3D

func _ready():
	# Connecte le signal de fin de timeline
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

func _process(delta):
	ui_interaction_mere.visible = player_in_area
	_state_dialogue()

func _input(event):
	if player_in_area and event.is_action_pressed("e"):
		if first_interaction:
			_timeline_album_photo()
			first_interaction = false
		elif interaction_with_carton:
			_timeline_photo_carton()
		elif interaction_without_carton:
			_timeline_photo_no_carton()

func _state_dialogue():
	var carton_pris = interaction_carton.get_bool_carton_pris()
	if not first_interaction and carton_pris:
		interaction_with_carton = true
		interaction_without_carton = false
	elif not first_interaction and not carton_pris:
		interaction_with_carton = false
		interaction_without_carton = true

func _on_mother_dialogue_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("dedans : ", body.name)

func _on_mother_dialogue_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print("sort : ", body.name)

# Timelines avec blocage du joueur
func _timeline_album_photo():
	player.lock_movement(true)
	Dialogic.start_timeline("AlbumPhoto")

func _timeline_photo_carton():
	player.lock_movement(true)
	Dialogic.start_timeline("AlbumPhotoCarton")

func _timeline_photo_no_carton():
	player.lock_movement(true)
	Dialogic.start_timeline("AlbumPhotoPasCarton")

# Déblocage du mouvement à la fin du dialogue
func _on_dialogic_timeline_ended():
	print("Timeline terminée")
	player.lock_movement(false)

func get_bool_interaction() -> bool:
	return first_interaction
