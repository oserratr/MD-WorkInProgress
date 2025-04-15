extends AnimatedSprite2D

@export var animation_name: String = "pressx"

func _ready():
	play(animation_name)
