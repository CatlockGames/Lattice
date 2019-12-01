extends Node2D

var foregroundPicker: ColorPickerButton
var background: TextureRect
var background_scale: float

var layers: VBoxContainer
onready var layerScene = preload("res://scenes/Layer.tscn")
var current_layer_index := 0

var size: Vector2
var focus := false

var prev_mouse_pos: Vector2

func _ready() -> void:
	foregroundPicker = find_parent("Main").find_node("Foreground")
	background = get_node("../TransparentBackground")
	background_scale = 10
	
	size = Vector2(64, 64)
	layers = find_parent("Main").find_node("Layers")
	_on_newLayer_pressed()

func _process(delta) -> void:
	update()
	var mouse_pos = get_local_mouse_position()
	var mouse_in_layer := Rect2(Vector2.ZERO, size).has_point(mouse_pos)
	
	# Draw pixels
	if Input.is_action_pressed("tool_primary") && mouse_in_layer:
		layers.get_child(current_layer_index).set_pixel(mouse_pos.x, mouse_pos.y, foregroundPicker.color)
	
	# Update layers textures as needed
	for layer in layers.get_children():
		layer.update_texture()
	
	# Update prev mouse position
	prev_mouse_pos = mouse_pos

func _draw() -> void:
	# Draw layers
	for layer in layers.get_children():
		if layer.show:
			draw_texture(layer.texture, Vector2.ZERO)

# Updates the transparent background grid
func update_background(zoom: Vector2) -> void:
	background.rect_scale = zoom * background_scale
	background.rect_size = size / zoom / background_scale

func update_selected_layer() -> void:
	for i in range(layers.get_child_count()):
		if i != current_layer_index && layers.get_child(i).find_node("Name").pressed:
			layers.get_child(i).find_node("Name").pressed = false

func _on_ViewportContainer_mouse_entered() -> void:
	focus = true

func _on_ViewportContainer_mouse_exited() -> void:
	focus = false

func _on_newLayer_pressed():
	var layer = layerScene.instance()
	layers.add_child(layer)
	layer.init(layers.get_child_count() - 1, size)
	layers.move_child(layers.get_child(layers.get_child_count() - 1), 0)
	current_layer_index = 0
	layers.get_child(0).find_node("Name").connect("toggled", find_parent("Main").find_node("Canvas"), "_on_Name_toggled", [layers.get_child(0)])
	update_selected_layer()

func _on_removeLayer_pressed():
	if layers.get_child_count() > 1:
		layers.remove_child(layers.get_child(current_layer_index))

func _on_Name_toggled(button_pressed: bool, layer: HBoxContainer):
	if button_pressed:
		current_layer_index = layer.get_index()
		update_selected_layer()
