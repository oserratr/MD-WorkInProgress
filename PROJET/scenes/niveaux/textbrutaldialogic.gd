extends Node3D

func _ready():
	# attendre que Dialogic soit prêt
	await get_tree().process_frame
	await get_tree().process_frame

	Dialogic.start("albumphoto")
