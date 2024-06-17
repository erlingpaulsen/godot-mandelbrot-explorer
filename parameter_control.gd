extends Control

signal parameter_changed(parameter_key: String, new_value: float)

@export var parameter_data: ParameterData

@onready var label: Label = $VBoxContainer/Label
@onready var slider: HSlider = $VBoxContainer/HBoxContainer/HSlider
@onready var value_label: Label = $VBoxContainer/HBoxContainer/CurrentValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = parameter_data.name
	slider.min_value = parameter_data.range[0]
	slider.max_value = parameter_data.range[1]
	slider.step = parameter_data.step
	set_parameter_value(parameter_data.default)
	

func set_parameter_value(new_value: float) -> void:
	slider.value = new_value
	value_label.text = String.num(new_value, 2)
	parameter_changed.emit(parameter_data.key, slider.value)


func _on_h_slider_value_changed(value: float) -> void:
	value_label.text = String.num(value, 2)
	parameter_changed.emit(parameter_data.key, value)
