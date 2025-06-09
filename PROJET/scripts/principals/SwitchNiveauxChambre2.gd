extends Node3D

var player_enter_salon = false
@export var ui_interaction: Control

func _ready():
	ui_interaction.visible = false
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	# Si tu veux garder l'écran noir fixe sans animation, tu peux laisser ça :
	# $"../CanvasLayer/ColorRect".modulate.a = 1.0  # Sinon supprime cette ligne aussi

func _process(delta):
	# Afficher ou non UI
	if player_enter_salon:
		ui_interaction.visible = true
		if Input.is_action_just_pressed("e"):
			_switch_chambre()
	else:
		ui_interaction.visible = false

func _switch_chambre():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	$"../CanvasLayer/AnimationPlayer".play("disolve")
	await $"../CanvasLayer/AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://scenes/niveaux/salon.tscn")
	$"../CanvasLayer/AnimationPlayer".play_backwards("disolve")

func _on_porte_salon_body_entered(body):
	if body.is_in_group("player"):
		player_enter_salon = true

func _on_porte_salon_body_exited(body):
	if body.is_in_group("player"):
		player_enter_salon = false
