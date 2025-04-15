extends AnimatedSprite2D

@export var animation_name: String = "rightzoom"

func _ready():
	play(animation_name)
