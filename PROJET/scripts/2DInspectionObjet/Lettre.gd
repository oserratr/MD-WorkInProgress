extends Area2D

@export var ui_node_path: Node2D  # L'UI à activer quand on clique

func _ready():
	input_pickable = true  # permet de détecter les clics
	ui_node_path.visible = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		ui_node_path.visible = true
		print("click")
