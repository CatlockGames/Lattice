extends Node2D

var layers := []
var current_layer_index := 0

var size: Vector2
var focus := false

var prev_mouse_pos: Vector2

func _ready() -> void:
	size = Vector2(64, 64)
	layers.append(Layer.new(size, Color.white))

func _process(delta) -> void:
	var mouse_pos = get_local_mouse_position()
	var mouse_in_layer := Rect2(Vector2.ZERO, size).has_point(mouse_pos)
	
	# Draw pixels
	if Input.is_action_pressed("tool_primary") && mouse_in_layer:
		layers[current_layer_index].set_pixel(mouse_pos.x, mouse_pos.y, Color.black)
	
	# Update layers textures as needed
	for layer in layers:
		layer.update_texture()
	
	# Update prev mouse position
	prev_mouse_pos = mouse_pos

func _draw() -> void:
	# Draw transparent background texture
	# TODO add checker pattern texture
	# need to draw the texture and scale/tile based on canvas size
	# draw_texture(background, Vector2.ZERO)
	
	# Draw layers
	for layer in layers:
		if layer.show:
			draw_texture(layer.texture, Vector2.ZERO)

func _on_ViewportContainer_mouse_entered() -> void:
	focus = true

func _on_ViewportContainer_mouse_exited() -> void:
	focus = false
