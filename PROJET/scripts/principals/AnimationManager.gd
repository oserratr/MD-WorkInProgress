extends Node3D

# Standing Idle Reading animation Mother
@export var animation_player_mere: AnimationPlayer
@export var animation_name_mere: String = "StandingIdleReading"
@export var animation_player_fille: AnimationPlayer
@export var animation_name_fille_walking: String = "walking"
@export var animation_name_fille_idle: String = "idle"
func _ready():
	# Standing Idle Reading animation Mother
		animation_player_mere.play(animation_name_mere)
		#animation_player_fille.play(animation_name_fille_idle)
	
