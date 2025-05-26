extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Cacher la souris au début
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	# Lancer la cinématique
	animation_player.play("CinematiqueTransition")
	
	# Connecter le signal de fin d'animation
	animation_player.animation_finished.connect(_on_cinematique_finished)

func _on_cinematique_finished(anim_name: String):
	if anim_name == "CinematiqueTransition":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
