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
	image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	if fill != Color(1, 1, 1, 0):
		image.fill(fill)
	texture.create_from_image(image, 0)
	show = true
	changed = false

# Sets the given pixel to the given color
func set_pixel(point: Vector2, color: Color) -> void:
	var x := int(point.x)
	var y := int(point.y)
	image.lock()
	if color != image.get_pixel(x, y):
		image.set_pixel(x, y, color)
		changed = true
	image.unlock()

# Draws a line from the given start point to end point with a color
# https://en.wikipedia.org/wiki/Bresenham's_line_algorithm
func draw_line(start: Vector2, end: Vector2, color: Color) -> void:
	var x0 := int(start.x)
	var y0 := int(start.y)
	var x1 := int(end.x)
	var y1 := int(end.y)
	
	var dx := abs(x1 - x0)
	var dy := -abs(y1 - y0)
	var sx := 1 if x0 < x1 else -1
	var sy := 1 if y0 < y1 else -1
	var error := dx + dy
	
	image.lock()
	while x0 != x1 || y0 != y1:
		image.set_pixel(x0, y0, color)
		var error2 = 2 * error
		if error2 >= dy:
			error += dy
			x0 += sx
		if error2 <= dx:
			error += dx
			y0 += sy
	image.unlock()
	changed = true

# Updates the layers texture if any changes were made to its image
func update_texture() -> void:
	if changed:
		texture.set_data(image)
		changed = false
