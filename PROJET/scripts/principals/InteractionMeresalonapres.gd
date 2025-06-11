extends Node3D

@export var player: Node3D
@export var player_camera: Camera3D
@export var camera_mere: Camera3D
@export var ui_interaction: Control
@export var ui_echap: Control
@export var ui_interaction_mere: Control
@export var ui_echap_mere: Control
@export var Mere: Node3D
@export var MerePhone: Node3D

var active_secondary_camera: Camera3D = null
var camera_switched := false
var player_enter_alo := false
var player_enter_dialogue_mere := false
var interaction_active := false
var mere_repositionnee := false
var timeline_active := false

func _ready():
	ui_interaction.visible = false
	ui_echap.visible = false
	ui_interaction_mere.visible = false
	ui_echap_mere.visible = false
	$"../MèreTelephone".visible = false

	if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)

func _process(delta):
	var tv_script = get_node("../InspectionObjetsSlice2")
	if tv_script and tv_script.tv_inspecter and not mere_repositionnee:
		print("📺 TV inspectée → mise à jour de Mère")
		if is_instance_valid(MerePhone):
			MerePhone.queue_free()
		Mere.global_transform.origin = Vector3(-0.729, -0.024, 2.348)
		mere_repositionnee = true

	# UI interaction alo
	ui_interaction.visible = player_enter_alo and not interaction_active

	# UI interaction mère
	ui_interaction_mere.visible = player_enter_dialogue_mere and not timeline_active

	# Interaction alo
	if player_enter_alo and Input.is_action_just_pressed("e") and not interaction_active:
		interaction_active = true
		$"../MèreTelephone".visible = true
		$"../MèreTelephone/InnerVoice/AnimationPlayer".play("Fade_up")
		ui_echap.visible = true
		_lock_chara()

	# Sortie alo
	if interaction_active and $"../MèreTelephone".visible and Input.is_action_just_pressed("ui_cancel"):
		$"../MèreTelephone".visible = false
		ui_echap.visible = false
		unlock_chara()
		interaction_active = false

	# Interaction avec la mère (timeline Nirina)
	if player_enter_dialogue_mere and not timeline_active and Input.is_action_just_pressed("e"):
		print("👩‍👧 Début de la timeline Nirina")
		_switch_to_camera(camera_mere)
		ui_echap_mere.visible = true
		_timeline_nirina()

func _timeline_nirina():
	timeline_active = true
	player.lock_movement(true)
	Dialogic.start_timeline("dialoguenirina")

func _on_dialogic_timeline_ended():
	print("Timeline terminée")
	timeline_active = false
	player.lock_movement(false)
	ui_echap_mere.visible = false
	_switch_to_player_camera()

func _switch_to_camera(cam: Camera3D):
	if cam == null:
		print("Erreur : La caméra secondaire n'est pas définie.")
		return

	active_secondary_camera = cam
	cam.current = true
	camera_switched = true
	ui_interaction.visible = false
	ui_interaction_mere.visible = false

	if player and "lock_movement" in player:
		player.lock_movement(true)

func _switch_to_player_camera():
	if active_secondary_camera:
		active_secondary_camera.current = false
	player_camera.current = true
	camera_switched = false
	active_secondary_camera = null
	player.lock_movement(false)

# Zones

func _on_telephonemere_body_entered(body):
	if body.is_in_group("player"):
		player_enter_alo = true

func _on_telephonemere_body_exited(body):
	if body.is_in_group("player"):
		player_enter_alo = false

func _on_mother_dialogue_body_entered(body):
	if body.is_in_group("player"):
		player_enter_dialogue_mere = true

func _on_mother_dialogue_body_exited(body):
	if body.is_in_group("player"):
		player_enter_dialogue_mere = false

func _lock_chara():
	if player and "lock_movement" in player:
		player.lock_movement(true)
	else:
		print("⚠️ Erreur : joueur non défini ou méthode lock_movement manquante.")

func unlock_chara():
	if player and "lock_movement" in player:
		player.lock_movement(false)
