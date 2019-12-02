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
	if color != image.get_pixel(x, y):
		image.set_pixel(x, y, color)
		changed = true
	image.unlock()

# Draws an ellipse
func draw_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var x_rad := int(radius.x)
	var y_rad := int(radius.y)
	var cx := int(center.x)
	var cy := int(center.y)
	
	var x := x_rad
	var y := 0
	var dx := y_rad * y_rad * (1 - 2 * x_rad)
	var dy := x_rad * x_rad
	var two_x_square := 2 * x_rad * x_rad
	var two_y_square := 2 * y_rad * y_rad
	var error := 0
	var stop_x := two_y_square * x_rad
	var stop_y := 0

	while stop_x >= stop_y:
		image.lock()
		image.set_pixel(cx + x, cy + y, color)
		image.set_pixel(cx - x, cy + y, color)
		image.set_pixel(cx + x, cy - y, color)
		image.set_pixel(cx - x, cy - y, color)
		image.unlock()
		y += 1
		stop_y += two_x_square
		error += dy
		dy += two_x_square
		if 2 * error + dx > 0:
			x -= 1
			stop_x -= two_y_square
			error += dx
			dx += two_y_square

	x = 0
	y = y_rad
	dx = y_rad * y_rad
	dy = x_rad * x_rad * (1 - 2 * y_rad)
	error = 0
	stop_x = 0
	stop_y = two_x_square * y_rad
	while stop_x <= stop_y:
		image.lock()
		image.set_pixel(cx + x, cy + y, color)
		image.set_pixel(cx - x, cy + y, color)
		image.set_pixel(cx + x, cy - y, color)
		image.set_pixel(cx - x, cy - y, color)
		image.unlock()
		x += 1
		stop_x += two_y_square
		error += dx
		dx += two_y_square
		if 2 * error + dy > 0:
			y -= 1
			stop_y -= two_x_square
			error += dy
			dy += two_x_square
	
	changed = true

# Updates the layers texture if any changes were made to its image
func update_texture() -> void:
	if changed:
		texture.set_data(image)
		changed = false
