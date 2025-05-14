extends Area3D


func _ready():
	connect("body_entered", Callable(self, "_on_area_3d_body_entered"))
	connect("body_exited", Callable(self, "_on_area_3d_body_exited"))
	

func _on_area_3d_body_entered(body):
	pass

func _on_area_3d_body_exited(body):
	pass

