extends AnimatedSprite2D

@export var animation_name: String = "pressex"

func _ready():
	play(animation_name)
