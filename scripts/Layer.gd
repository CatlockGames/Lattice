class_name Layer

var image: Image
var texture: ImageTexture
var size: Vector2
var show: bool
var changed: bool

# Layer constructor
# Creates a new layer with the given size
# Optionally set the fill color, default to transparent
func _init(size: Vector2, fill := Color(1, 1, 1, 0)) -> void:
	self.size = size
	image = Image.new()
	texture = ImageTexture.new()
	image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	if fill != Color(1, 1, 1, 0):
		image.fill(fill)
	texture.create_from_image(image, 0)
	show = true
	changed = false

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
	
	var size_rect := Rect2(Vector2.ZERO, size)
	image.lock()
	while x0 != x1 || y0 != y1:
		if size_rect.has_point(Vector2(x0, y0)):
			image.set_pixel(x0, y0, color)
			changed = true
		var error2 = 2 * error
		if error2 >= dy:
			error += dy
			x0 += sx
		if error2 <= dx:
			error += dx
			y0 += sy
	if size_rect.has_point(Vector2(x0, y0)):
		image.set_pixel(x0, y0, color)
		changed = true
	image.unlock()

# Draws an ellipse
func draw_ellipse(center: Vector2, radius: Vector2, color: Color) -> void:
	var x_rad := int(radius.x)
	var y_rad := int(radius.y)
	var cx := int(center.x)
	var cy := int(center.y)
	
	if x_rad == 0 || y_rad == 0: # Just a line
		draw_line(center + radius, center - radius, color)
	elif x_rad == 1: # Thin vertical ellipse
		draw_line(Vector2(center.x, center.y + radius.y), Vector2(center.x, center.y + radius.y), color)
		draw_line(Vector2(center.x, center.y - radius.y), Vector2(center.x, center.y - radius.y), color)
		draw_line(Vector2(center.x + 1, center.y + radius.y - 1), Vector2(center.x + 1, center.y - radius.y + 1), color)
		draw_line(Vector2(center.x - 1, center.y + radius.y - 1), Vector2(center.x - 1, center.y - radius.y + 1), color)
	elif y_rad == 1: # Thin horizontal ellipse
		draw_line(Vector2(center.x + radius.x, center.y), Vector2(center.x + radius.x, center.y), color)
		draw_line(Vector2(center.x - radius.x, center.y), Vector2(center.x - radius.x, center.y), color)
		draw_line(Vector2(center.x + radius.x - 1, center.y + 1), Vector2(center.x - radius.x + 1, center.y + 1), color)
		draw_line(Vector2(center.x + radius.x - 1, center.y - 1), Vector2(center.x - radius.x + 1, center.y - 1), color)
	else: # Normal ellipse algorithm
		changed = true
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

# Updates the layers texture if any changes were made to its image
func update_texture() -> void:
	if changed:
		texture.set_data(image)
		changed = false
