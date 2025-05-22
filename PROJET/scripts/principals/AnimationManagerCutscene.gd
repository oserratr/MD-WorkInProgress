extends Node3D

@export var animation_player_fille: AnimationPlayer
@export var animation_name_fille_talking: String = "talking"
func _ready():
	# Standing Idle Reading animation Mother
		animation_player_fille.play(animation_name_fille_talking)
