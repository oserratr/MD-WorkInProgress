extends Node3D

# Standing Idle Reading animation Mother
@export var animation_player_mere: AnimationPlayer
@export var animation_name_mere: String = "phonecall"

func _ready():
	# Standing Idle phone animation Mother
		animation_player_mere.play(animation_name_mere)

	
