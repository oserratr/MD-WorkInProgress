extends Node3D

@export var trigger_camera: Camera3D  # assignée dans l'inspecteur
@export var suz : Node3D

var pressed := false
var default_transform: Transform3D
var default_suz_rotation: Vector3

func _ready():
	default_transform = global_transform
	default_suz_rotation = suz.rotation

func _input(event: InputEvent) -> void:
	if trigger_camera.current and pressed and event is InputEventMouseMotion:
		rotation.x += event.relative.y * 0.005
		suz.rotation.y += event.relative.x * 0.005

func _physics_process(delta: float) -> void:
	if not trigger_camera.current:
		return

	if Input.is_action_just_pressed("click"):
		pressed = true
	if Input.is_action_just_released("click"):
		pressed = false

	if Input.is_action_just_pressed("ui_cancel"):
		global_transform = default_transform
		suz.rotation = default_suz_rotation
		pressed = false
