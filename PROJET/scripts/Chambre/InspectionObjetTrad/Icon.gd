extends Area2D

@export var lettre_inventaire: CanvasLayer

func _ready():
	input_pickable = true
	lettre_inventaire.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_inventory"):
		lettre_inventaire.visible = not lettre_inventaire.visible
		print("Lettre visible :", lettre_inventaire.visible)
