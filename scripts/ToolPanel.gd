extends PanelContainer

var foregroundPicker: ColorPickerButton
var backgroundPicker: ColorPickerButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	foregroundPicker = $Tools/FGBG/Foreground
	backgroundPicker = $Tools/FGBG/Background
	foregroundPicker.color = Color.black
	backgroundPicker.color = Color.white

# Swaps foreground and background color
func _on_Swap_pressed() -> void:
	var temp := foregroundPicker.color
	foregroundPicker.color = backgroundPicker.color
	backgroundPicker.color = temp

# Reverts colors do black and white default
func _on_BW_pressed() -> void:
	foregroundPicker.color = Color.black
	backgroundPicker.color = Color.white
