extends HBoxContainer
class_name Layer

var image: Image
var texture: ImageTexture
var show: bool
var changed: bool
var selected: bool

var canvas: Node2D

# Layer constructor
# Creates a new layer with the given size
# Optionally set the fill color, default to transparent
func init(index: int, size: Vector2, fill := Color(1, 1, 1, 0)) -> void:
	canvas = find_parent("Main").find_node("Canvas")
	$Name.text = "Layer %d" % index
	image = Image.new()
	texture = ImageTexture.new()
	image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	if fill != Color(1, 1, 1, 0):
		image.fill(fill)
	texture.create_from_image(image, 0)
	show = true
	changed = false
	selected = true

# Sets the given pixel to the given color
func set_pixel(x: int, y: int, color: Color) -> void:
	image.lock()
	image.set_pixel(x, y, color)
	image.unlock()
	changed = true

# Updates the layers texture if any changes were made to its image
func update_texture() -> void:
	if changed:
		texture.set_data(image)
		changed = false

func _on_Show_toggled(button_pressed):
	show = !button_pressed

func _on_Name_toggled(button_pressed):
	if button_pressed:
		$Selected.texture = load("res://assets/graphics/layers/selected.png")
		selected = true
	else:
		$Selected.texture = load("res://assets/graphics/layers/deselected.png")
		selected = false