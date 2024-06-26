extends VBoxContainer

@export var top_left_value: Label
@export var bottom_right_value: Label
@export var scale_value: Label
@export var mouse_value: Label
@export var frametime_value: Label
@export var fps_value: Label

func _ready() -> void:
	SignalBus.coordinates_updated.connect(_on_coordinates_updated)
	SignalBus.mouse_coordinates_updated.connect(_on_mouse_coordinates_updated)
	SignalBus.scale_updated.connect(_on_scale_updated)


func _physics_process(_delta: float):
	frametime_value.text = str(Performance.get_monitor(Performance.TIME_PROCESS) * 1000) + ' ms'
	fps_value.text = str(Performance.get_monitor(Performance.TIME_FPS))


func _on_coordinates_updated(top_left: Vector2, bottom_right: Vector2) -> void:
	top_left_value.text = str(top_left)
	bottom_right_value.text = str(bottom_right)


func _on_mouse_coordinates_updated(mouse_pos: Vector2) -> void:
	mouse_value.text = str(mouse_pos)


func _on_scale_updated(new_scale: float) -> void:
	scale_value.text = str(new_scale)
