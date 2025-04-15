extends AnimatedSprite2D

@export var animation_name: String = "leftzoom"

func _ready():
	play(animation_name)
