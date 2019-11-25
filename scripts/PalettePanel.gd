extends PanelContainer

var foregroundPicker: ColorPickerButton

# Called when the node enters the scene tree for the first time.
func _ready():
	foregroundPicker = find_parent("Main").find_node("Foreground")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AddColor_pressed():
	var image = Image.new()
	var texture = ImageTexture.new()
	
	image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(foregroundPicker.color)
	texture.create_from_image(image)
	
	$Palette/Colors.add_icon_item(texture)


func _on_RemoveColor_pressed():
	if $Palette/Colors.is_anything_selected():
		var selected = $Palette/Colors.get_selected_items()[0]
		$Palette/Colors.remove_item(selected)


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Colors_item_selected(index):
	var icon = $Palette/Colors.get_item_icon(index).get_data()
	icon.lock()
	foregroundPicker.color = icon.get_pixel(1, 1)