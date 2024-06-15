extends HBoxContainer

@export var scale_value: Label

func _on_mandelbrot_scale_updated(new_scale: float) -> void:
	scale_value.text = str(new_scale)
