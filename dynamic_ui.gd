extends Node

var font: FontFile = load("res://MonaspaceArgon-Regular.otf")

const FONT_SIZE_REGULAR_MIN := 10
const FONT_SIZE_REGULAR_MAX := 26
const FONT_SIZE_HEADING_MIN := 18
const FONT_SIZE_HEADING_MAX := 48

func _get_font_size(f: float) -> float:
	var vp := get_viewport()
	var font_size = f * min(0.01 * vp.size.x, 0.01 * vp.size.y)
	return round(font_size)
	
func get_font_size_regular() -> float:
	return clamp(_get_font_size(1.2), FONT_SIZE_REGULAR_MIN, FONT_SIZE_REGULAR_MAX)
	
func get_font_size_heading() -> float:
	return _get_font_size(4.5)

func get_font() -> FontFile:
	return font
	
func get_margin() -> int:
	var vp := get_viewport()
	var margin = round(2 * min(0.01 * vp.size.x, 0.01 * vp.size.y))
	return clamp(margin, 10, 50)
