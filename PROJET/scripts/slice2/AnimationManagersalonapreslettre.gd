extends Node3D

# Standing Idle Reading animation Mother
@export var animation_player_mere: AnimationPlayer
@export var animation_name_mere: String = "phonecall"
@export var animation_player_mere2: AnimationPlayer
@export var animation_name_mere2: String = "Idle"

func _ready():
	# Standing Idle phone animation Mother
		animation_player_mere.play(animation_name_mere)
		animation_player_mere2.play(animation_name_mere2)

	
