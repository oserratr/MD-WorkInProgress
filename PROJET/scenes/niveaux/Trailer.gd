extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Plan2")
func _process(delta):
	$"../Mere/AnimationMere/AnimationPlayer".play("StandingIdleReading")
