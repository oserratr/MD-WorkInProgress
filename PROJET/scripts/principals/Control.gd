extends Control

var sensitivity : float = 600.0
var deadzone : float = 0.2
var x_axis: float = 0.0
var y_axis: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if event.axis == 0:  # Axe X
			x_axis = event.axis_value if abs(event.axis_value) > deadzone else 0.0
		elif event.axis == 1:  # Axe Y
			y_axis = event.axis_value if abs(event.axis_value) > deadzone else 0.0

func _process(delta: float) -> void:
	if x_axis != 0.0 or y_axis != 0.0:
		var mouse_pos = get_viewport().get_mouse_position()
		var movement = Vector2(x_axis, y_axis) * sensitivity * delta
		Input.warp_mouse(mouse_pos + movement)
