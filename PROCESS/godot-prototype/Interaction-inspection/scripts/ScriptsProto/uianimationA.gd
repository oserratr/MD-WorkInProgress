extends AnimatedSprite2D

@export var animation_name: String = "pressed"

func _ready():
	play(animation_name)
