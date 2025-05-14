extends Node3D

var player_in_area = false
var first_interaction = true
var interaction_with_carton = false
var interaction_without_carton = false

@export var interaction_carton = Node3D

func _process(delta):
	_state_dialogue()

func _input(event):
	if player_in_area and event.is_action_pressed("e"):
		if first_interaction:
			_timeline_album_photo()
			first_interaction = false
		elif interaction_with_carton :
			print("start")
			_timeline_photo_carton()
		elif interaction_without_carton and not first_interaction:
			_timeline_photo_no_carton()
			print("start")



func _state_dialogue():
	var interaction_carton = interaction_carton.get_bool_carton_pris()
	
	if not first_interaction and interaction_carton : 
		interaction_with_carton = true
		interaction_without_carton = false
	elif not first_interaction and not interaction_carton :
		interaction_with_carton = false
		interaction_without_carton = true
	
func _on_mother_dialogue_body_entered(body):
	print("Test : body entered")
	if body.is_in_group("player"):
		player_in_area = true
		print("dedans : ", body.name)

func _on_mother_dialogue_body_exited(body):
	print("Test : body exited")
	if body.is_in_group("player"):
		player_in_area = false
		print("sort : ", body.name)


func _timeline_album_photo():
	Dialogic.start_timeline("AlbumPhoto")
	
func _timeline_photo_carton():
	Dialogic.start_timeline("AlbumPhotoCarton")
	
func _timeline_photo_no_carton():
	Dialogic.start_timeline("AlbumPhotoPasCarton")
	
func get_bool_interaction() -> bool:
	return first_interaction
