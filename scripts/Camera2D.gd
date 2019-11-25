extends Camera2D

var drag := false
var zoom_step := 1.1

func _ready() -> void:
	pass

func _input(event) -> void:
	# Dragging
	if event.is_action_pressed("canvas_drag"):
		drag = true
	elif event.is_action_released("canvas_drag"):
		drag = false
	if event is InputEventMouseMotion && drag:
		offset -= event.relative * zoom
	
	# Zooming
	if event is InputEventMouse:
		if event.is_action_pressed("canvas_zoom_in"):
			zoom_camera(1 / zoom_step, event.position)
		elif event.is_action_pressed("canvas_zoom_out"):
			zoom_camera(zoom_step, event.position)

func zoom_camera(amount: float, target: Vector2) -> void:
	offset += (-0.5 * get_viewport().size + target) * (zoom - zoom * amount)
	zoom = zoom * amount