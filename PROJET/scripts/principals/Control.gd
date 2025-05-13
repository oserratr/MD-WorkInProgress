extends Control

var sensitivity : float = 600.0
var x_axis: float =0.0
var y_axis: float =0.0

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion :
		if event.axis == 0:
				x_axis = event.axis_value
		if event.axis == 1:
				y_axis = event.axis_value
	#print(x_axis,y_axis)

func _process(delta: float) -> void :
	if InputEventJoypadMotion :
			if x_axis != 0.0 or y_axis != 0.0:
					var mouse_pos = get_viewport().get_mouse_position()
					var new_mouse_pos = mouse_pos + Vector2(x_axis, y_axis) * sensitivity * delta
					Input.warp_mouse(new_mouse_pos)
