extends HBoxContainer

@export var scale_value: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mandelbrot_scale_updated(new_scale: float) -> void:
	scale_value.text = str(new_scale)
