extends HBoxContainer

var size: Vector2
var image: Image
var texture: ImageTexture
var show: bool
var changed: bool
var preview_image: Image
var preview_texture: ImageTexture

# Layer constructor
# Creates a new layer with the given size
# Optionally set the fill color, default to transparent
func init(index: int, size: Vector2, fill := Color(1, 1, 1, 0)) -> void:
	$Name.text = "Layer %d" % index
	self.size = size
	
	# Initialize canvas image
	image = Image.new()
	texture = ImageTexture.new()
	image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	if fill != Color(1, 1, 1, 0):
		image.fill(fill)
	texture.create_from_image(image, 0)
	show = true
	changed = false
	
	# Initialize preview image
	preview_image = Image.new()
	preview_image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	preview_texture = ImageTexture.new()
	preview_texture.create_from_image(preview_image, 0)
	update_preview()

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
		update_preview()

# Updates the preview image for each layer from the canvas
func update_preview() -> void:
	preview_image.fill(Color.white)
	preview_image.blend_rect(image, Rect2(Vector2.ZERO, size), Vector2.ZERO)
	preview_texture.set_data(preview_image)
	preview_texture.set_size_override(Vector2(32 * size.aspect(), 32))
	$Preview.texture = preview_texture

func _on_Show_toggled(button_pressed):
	show = !button_pressed
