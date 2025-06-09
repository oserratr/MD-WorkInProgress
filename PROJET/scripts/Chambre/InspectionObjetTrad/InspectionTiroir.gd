extends Control

@export var ui_innervoice : Control
@export var ui_echap : Control
var lettre_trouve = false

func _ready():
	ui_innervoice.visible = false
	ui_echap.visible = false

func _process(delta):
	var lettre_node = get_node("Lettre/Lettre")
	
	# Si on clique la lettre
	if lettre_node.clicklettre and not lettre_trouve:
		lettre_trouve = true
		_innervoice()
	
	# Si l'UI d'échappement est visible et que le joueur appuie sur "ui_cancel"
	if ui_echap.visible and Input.is_action_just_pressed("ui_cancel"):
		# Remplace ici par le chemin vers la scène que tu veux charger
		get_tree().change_scene_to_file("res://scenes/NiveauxLettre/chambreapreslettre.tscn")


func _innervoice():
	ui_innervoice.visible = true
	$InnerVoice/AnimationPlayer.play("Fade_up")
	ui_echap.visible = false
	$InnervoiceTimer.start(5.0)

func _on_innervoice_timer_timeout():
	ui_innervoice.visible = false
	ui_echap.visible = true
