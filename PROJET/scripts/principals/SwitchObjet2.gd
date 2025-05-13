extends Area3D

@export var target_camera: Camera3D
@onready var controller = $"../../../InteractionObjet"

func _ready():
	connect("body_entered", Callable(self, "_on_area_3d_body_entered"))
	connect("body_exited", Callable(self, "_on_area_3d_body_exited"))

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		controller.active_secondary_camera = target_camera
		controller._on_tableau_2_body_entered(body)
		print("Camera assigned to:", target_camera)

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		controller._on_tableau_2_body_exited(body)
