extends Control

@export var mandelbrot_canvas: ColorRect
@export var mandelbrot_container: MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_font()
	_update_font_size()
	_update_margins()
	get_viewport().connect('size_changed', _on_viewport_size_changed)
	print(mandelbrot_container.is_node_ready(), mandelbrot_container.size)
	print(mandelbrot_canvas.is_node_ready())
	mandelbrot_canvas.update_size(mandelbrot_container.size - Vector2(40,0))
	print(mandelbrot_container.size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#mandelbrot_canvas.update_size(mandelbrot_container.size - Vector2(40,0))

func _update_font() -> void:
	var font = DynamicUI.get_font()
	for child in find_children('*', 'Label', true, true):
		child.add_theme_font_override('font', font)

func _update_font_size() -> void:
	var font_size_regular = DynamicUI.get_font_size_regular()
	var font_size_heading = DynamicUI.get_font_size_heading()
	for child in find_children('*', 'Label', true, true):
		if 'Title' in child.name:
			child.add_theme_font_size_override('font_size', font_size_heading)
		else:
			child.add_theme_font_size_override('font_size', font_size_regular)

func _update_margins() -> void:
	var margin = DynamicUI.get_margin()
	for child in find_children('*', 'MarginContainer', true, true):
		child.add_theme_constant_override('margin_top', margin)
		child.add_theme_constant_override('margin_bottom', margin)
		child.add_theme_constant_override('margin_left', margin)
		child.add_theme_constant_override('margin_right', margin)
		
func _on_viewport_size_changed():
	_update_font_size()
	_update_margins()
	mandelbrot_canvas.update_size(mandelbrot_container.size - Vector2(40,0))
