extends ViewportContainer

var textureRect: TextureRect
var layers := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textureRect = $Viewport/TextureRect
	
	var image := Image.new()
	image.create(16, 16, false, Image.FORMAT_RGBA8)
	#image.set_pixel(10, 10, Color.red)
	image.fill(Color.red)
	var texture := ImageTexture.new()
	texture.create_from_image(image)
	layers.append([image, texture])
	#textureRect.texture.draw(Vector2(20, 20), Color(1, 1, 1, 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta) -> void:
#	pass

func _draw() -> void:
	# Transparent background image
	#todo checker pattern texture
	#draw_texture(layers[0][1], Vector2(50, 50))
	textureRect.texture = layers[0][1]