extends Node3D

# Accès au joueur
@export var player: CharacterBody3D

var playerAssis: bool = true

func _process(delta):
	if player == null:
		return

	# Gérer l’état assis/debout
	if (playerAssis==true):
		# Joueur assis → bloquer les mouvements du player


