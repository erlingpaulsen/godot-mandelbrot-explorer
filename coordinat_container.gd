extends VBoxContainer

@export var top_left_value: Label
@export var bottom_right_value: Label
@export var mouse_value: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mandelbrot_coordinates_updated(top_left: Vector2, bottom_right: Vector2) -> void:
	top_left_value.text = str(top_left)
	bottom_right_value.text = str(bottom_right)


func _on_mandelbrot_local_mouse_coordinates_updated(mouse_pos: Vector2) -> void:
	mouse_value.text = str(mouse_pos)
