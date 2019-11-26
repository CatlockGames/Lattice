extends PanelContainer

var colors: ItemList
var foregroundPicker: ColorPickerButton

func _ready():
	colors = $Palette/Colors
	foregroundPicker = find_parent("Main").find_node("Foreground")

# Adds the current foreground color to the palette
func _on_AddColor_pressed():
	var image := Image.new()
	var texture := ImageTexture.new()
	
	image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(foregroundPicker.color)
	texture.create_from_image(image)
	colors.add_icon_item(texture)

# Removes selected square from the palette
func _on_RemoveColor_pressed():
	if colors.is_anything_selected():
		var selected = colors.get_selected_items()[0]
		colors.remove_item(selected)

# Palette settings
func _on_Settings_pressed():
	pass # Replace with function body.

# Sets foreground color to selected palette square
func _on_Colors_item_selected(index):
	var icon = colors.get_item_icon(index).get_data()
	icon.lock()
	foregroundPicker.color = icon.get_pixel(0, 0)
	icon.unlock()
