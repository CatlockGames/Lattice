extends Control

var layers := []
var size: Vector2

func _ready() -> void:
	size = Vector2(16, 16)
	add_layer()
	layers[0].set_pixel(10, 10, Color.white)

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
		if layer.visible:
			draw_texture(layer.texture, Vector2.ZERO)

func add_layer() -> void:
	var image := Image.new()
	var texture := ImageTexture.new()
	image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	texture.create_from_image(image, 0)
	layers.append(Layer.new(image, texture))

class Layer:
	var image: Image
	var texture: ImageTexture
	var visible: bool
	var changed: bool
	
	func _init(image: Image, texture: ImageTexture) -> void:
		self.image = image
		self.texture = texture
		self.visible = true
		self.changed = false
	
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