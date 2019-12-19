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
	layers.get_child(current_layer_index).find_node("Name").pressed = true

# warning-ignore:unused_argument
func _process(delta) -> void:
	update()
	var mouse_pos = get_local_mouse_position()
	var mouse_in_layer := Rect2(Vector2.ZERO, size).has_point(mouse_pos) || Rect2(Vector2.ZERO, size).has_point(prev_mouse_pos)
	
	# Only use tools if the canvas is in focus
	if focus:
		if Input.is_action_pressed("tool_mod1"):
			if Input.is_action_pressed("tool_primary"):
				#current_tool.primary_mod1()
				pass
			if Input.is_action_pressed("tool_secondary"):
				#current_tool.secondary_mod1()
				pass
		elif Input.is_action_pressed("tool_mod2"):
			if Input.is_action_pressed("tool_primary"):
				#current_tool.primary_mod2()
				pass
			if Input.is_action_pressed("tool_secondary"):
				#current_tool.secondary_mod2()
				pass
		elif Input.is_action_pressed("tool_mod3"):
			if Input.is_action_pressed("tool_primary"):
				#current_tool.primary_mod3()
				pass
			if Input.is_action_pressed("tool_secondary"):
				#current_tool.secondary_mod3()
				pass
		
		# Temporary default only draw tool
		if Input.is_action_pressed("tool_primary") && mouse_in_layer:
			layers.get_child(current_layer_index).draw_sline(prev_mouse_pos, mouse_pos, foregroundPicker.color)
	
	# Update layers textures after all/any changes
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

func _on_ViewportContainer_mouse_entered() -> void:
	focus = true

func _on_ViewportContainer_mouse_exited() -> void:
	focus = false

# Creates a new layer above the currently selected layer
func _on_newLayer_pressed():
	var layer = layerScene.instance()
	layers.add_child(layer)
	layer.init("Layer %d" % (layers.get_child_count() - 1), size)
	layers.get_child(current_layer_index).find_node("Name").pressed = false
	layers.move_child(layers.get_child(layers.get_child_count() - 1), current_layer_index)
	var curr_layer = layers.get_child(current_layer_index)
	curr_layer.find_node("Name").connect("toggled", self, "_on_Name_toggled", [curr_layer])

# Removes the currently selected layer
func _on_removeLayer_pressed():
	if layers.get_child_count() > 1:
		layers.remove_child(layers.get_child(current_layer_index))
		if current_layer_index == layers.get_child_count():
			current_layer_index = layers.get_child_count() - 1
		layers.get_child(current_layer_index).get_node("Name").pressed = true

# Duplicates the currently selected layer
func _on_duplicate_pressed():
	var old_layer = layers.get_child(current_layer_index)
	_on_newLayer_pressed()
	var new_layer = layers.get_child(current_layer_index)
	new_layer.image.copy_from(old_layer.image)
	new_layer.changed = true
	new_layer.get_node("Name").text = old_layer.get_node("Name").text + " copy"

# Merges the currently selected layer to the one below
func _on_merge_pressed():
	if current_layer_index != layers.get_child_count() - 1:
		var old_layer = layers.get_child(current_layer_index)
		layers.remove_child(old_layer)
		var new_layer = layers.get_child(current_layer_index)
		new_layer.get_node("Name").pressed = true
		new_layer.image.blend_rect(old_layer.image, Rect2(Vector2.ZERO, size), Vector2.ZERO)
		new_layer.changed = true

func _on_Name_toggled(button_pressed: bool, layer: HBoxContainer):
	if button_pressed:
		layers.get_child(current_layer_index).find_node("Name").pressed = false
		current_layer_index = layer.get_index()
	elif !button_pressed && (current_layer_index == layer.get_index()):
		layer.get_node("Name").pressed = true
