extends AnimatedSprite2D

@export var animation_name: String = "deplacement"

func _ready():
	play(animation_name)
