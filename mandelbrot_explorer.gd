extends Control

@export var mandelbrot_canvas: ColorRect
@export var mandelbrot_container: MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mandelbrot_canvas.update_size(mandelbrot_container.size - Vector2(40,0))
