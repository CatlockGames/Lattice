class_name Layer

var image: Image
var texture: ImageTexture
var show: bool
var changed: bool

# Layer constructor
# Creates a new layer with the given size
# Optionally set the fill color, default to transparent
func _init(size: Vector2, fill := Color(1, 1, 1, 0)) -> void:
	image = Image.new()
	texture = ImageTexture.new()
	image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	if fill != Color(1, 1, 1, 0):
		image.fill(fill)
	texture.create_from_image(image, 0)
	show = true
	changed = false

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