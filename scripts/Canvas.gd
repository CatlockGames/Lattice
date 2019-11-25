extends Node2D

var layers := []
var size: Vector2
var focus := false

func _ready() -> void:
	size = Vector2(16, 16)
	layers.append(Layer.new(size, Color.white))

func _process(delta) -> void:
	# Update layers textures as needed
	for layer in layers:
		layer.update_texture()

func _draw() -> void:
	# Draw transparent background texture
	# TODO add checker pattern texture
	# draw_texture(background, Vector2.ZERO)
	
	# Draw layers
	for layer in layers:
		if layer.show:
			draw_texture(layer.texture, Vector2.ZERO)

func _on_ViewportContainer_mouse_entered() -> void:
	focus = true

func _on_ViewportContainer_mouse_exited() -> void:
	focus = false
