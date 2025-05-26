extends Node3D

@export var animation_player_fille: AnimationPlayer
@export var animation_player_fille_assoir: AnimationPlayer
@export var animation_player_fille_talking: AnimationPlayer
@export var animation_name_fille_talking: String = "talking"
@export var animation_name_fille_assoir: String = "assoir"
@export var animation_name_fille_talking2: String = "sitttalking2"
func _ready():
	# Standing Idle Reading animation Mother
		animation_player_fille.play(animation_name_fille_talking)
		animation_player_fille_assoir.play(animation_name_fille_assoir)
		animation_player_fille_talking.play(animation_name_fille_talking2)
