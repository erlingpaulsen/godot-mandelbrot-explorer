extends Control

var margin: int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_font_size()
	_update_margins()
	get_viewport().connect('size_changed', _on_viewport_size_changed)


func _update_font_size() -> void:
	var font_size_regular = DynamicUI.get_font_size_regular()
	var font_size_heading = DynamicUI.get_font_size_heading()
	var font_size_button = DynamicUI.get_font_size_button()
	for child in find_children('*', 'Label', true, true):
		if 'Title' in child.name:
			child.add_theme_font_size_override('font_size', font_size_heading)
		else:
			child.add_theme_font_size_override('font_size', font_size_regular)
	for child in find_children('*', 'Button', true, true):
		child.add_theme_font_size_override('font_size', font_size_button)


func _update_margins() -> void:
	margin = DynamicUI.get_margin()
	for child in find_children('*', 'MarginContainer', true, true):
		child.add_theme_constant_override('margin_top', margin)
		child.add_theme_constant_override('margin_bottom', margin)
		child.add_theme_constant_override('margin_left', margin)
		child.add_theme_constant_override('margin_right', margin)


func _on_viewport_size_changed():
	_update_font_size()
	_update_margins()
