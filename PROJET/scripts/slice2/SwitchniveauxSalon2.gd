extends Node3D

var player_enter_chambre = false
var player_enter_grenier = false
@export var ui_interaction: Control

func _ready():
	ui_interaction.visible = false
	# Masque la scène derrière une frame noire initiale
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	var canvas_anim = $"../CanvasLayer/AnimationPlayer"
	var fade_rect = $"../CanvasLayer/ColorRect"  # ou autre node visuel utilisé

	# S'assurer que le fondu est à l'état "opaque" AVANT que l'écran s'affiche
	fade_rect.modulate.a = 1.0  # ou fade_rect.visible = true si c’est un Sprite
	await get_tree().create_timer(0.01).timeout  # attendre une frame pour éviter le flash

	canvas_anim.play("solve")
	await canvas_anim.animation_finished
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	
	# Afficher ou non UI
	if player_enter_chambre :
		ui_interaction.visible = true
		if Input.is_action_just_pressed("e"):
			_switch_chambre()
	elif player_enter_grenier :
		ui_interaction.visible = true
		if Input.is_action_just_pressed("e"):
			_switch_grenier()
	else :
		ui_interaction.visible = false
	
	
func _switch_chambre():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	$"../CanvasLayer/AnimationPlayer".play("disolve")
	await $"../CanvasLayer/AnimationPlayer".animation_finished
	GlobalSceneState.previous_scene_name = get_tree().current_scene.name
	get_tree().change_scene_to_file("res://scenes/NiveauxLettre/chambreapreslettretrad.tscn")
	$"../CanvasLayer/AnimationPlayer".play_backwards("disolve")

func _switch_grenier():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	$"../CanvasLayer/AnimationPlayer".play("disolve")
	await $"../CanvasLayer/AnimationPlayer".animation_finished
	GlobalSceneState.previous_scene_name = get_tree().current_scene.name
	get_tree().change_scene_to_file("res://scenes/niveaux/grenierApcarton.tscn")
	$"../CanvasLayer/AnimationPlayer".play_backwards("disolve")
	
func _on_porte_chambre_body_entered(body):
	if body.is_in_group("player"):
		player_enter_chambre = true


func _on_porte_chambre_body_exited(body):
	if body.is_in_group("player"):
		player_enter_chambre = false


func _on_porte_grenier_body_entered(body):
	if body.is_in_group("player"):
		player_enter_grenier = true


func _on_porte_grenier_body_exited(body):
	if body.is_in_group("player"):
		player_enter_grenier = false
