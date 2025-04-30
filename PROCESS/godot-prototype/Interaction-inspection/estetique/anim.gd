extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("idle")  # Assure-toi que le nom correspond à celui dans l'inspecteur

