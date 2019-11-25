extends Camera2D

var drag := false
var zoom_step := 1.1
var canvas: Node2D

func _ready() -> void:
	canvas = get_node("../Canvas")

func _input(event) -> void:
	# Only affect canvas if in focus
	if canvas.focus:
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

# Zooms the camera by the given amount to the target location
func zoom_camera(amount: float, target: Vector2) -> void:
	offset += (-0.5 * get_viewport().size + target) * (zoom - zoom * amount)
	zoom = zoom * amount