extends Node2D

var foregroundPicker: ColorPickerButton
var background: TextureRect

var layers := []
var current_layer_index := 0

var size: Vector2
var focus := false

var prev_mouse_pos: Vector2

func _ready() -> void:
	foregroundPicker = find_parent("Main").find_node("Foreground")
	background = get_node("../TransparentBackground")
	
	size = Vector2(16, 16)
	layers.append(Layer.new(size, Color(255, 0, 0, 0.5)))

func _process(delta) -> void:
	var mouse_pos = get_local_mouse_position()
	var mouse_in_layer := Rect2(Vector2.ZERO, size).has_point(mouse_pos)
	
	# Draw pixels
	if Input.is_action_pressed("tool_primary") && mouse_in_layer:
		layers[current_layer_index].set_pixel(mouse_pos.x, mouse_pos.y, foregroundPicker.color)
	
	# Update layers textures as needed
	for layer in layers:
		layer.update_texture()
	
	# Update prev mouse position
	prev_mouse_pos = mouse_pos

func _draw() -> void:
	# Draw layers
	for layer in layers:
		if layer.show:
			draw_texture(layer.texture, Vector2.ZERO)

func update_background(zoom: float) -> void:
	print(zoom)
	var xy_ratio = size.x / size.y
	var scale = Vector2(sqrt(size.y), sqrt(size.y))
	var scale_factor = sqrt(size.y)
	background.rect_scale = scale * zoom * scale_factor
	scale.x *= xy_ratio
	background.rect_size = scale / zoom / scale_factor
	

func _on_ViewportContainer_mouse_entered() -> void:
	focus = true

func _on_ViewportContainer_mouse_exited() -> void:
	focus = false
