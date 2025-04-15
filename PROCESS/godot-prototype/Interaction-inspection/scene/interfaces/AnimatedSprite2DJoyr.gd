extends AnimatedSprite2D

@export var animation_name: String = "rotate"

func _ready():
	play(animation_name)
