class_name ParameterControl
extends Control

@export var parameter_data: ParameterData

@onready var label: Label = $VBoxContainer/Label
@onready var slider: HSlider = $VBoxContainer/HBoxContainer/HSlider
@onready var value_label: Label = $VBoxContainer/HBoxContainer/CurrentValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = parameter_data.name
	slider.min_value = parameter_data.value_range[0]
	slider.max_value = parameter_data.value_range[1]
	slider.step = parameter_data.step
	SignalBus.preset_loaded.connect(_on_preset_loaded)
	SignalBus.parameter_ready.emit(self)
	

func set_parameter_value(new_value: float) -> void:
	#print_debug('Parameter ', parameter_data.key, ' set to ', new_value)
	slider.value = new_value
	value_label.text = String.num(new_value, 2)
	SignalBus.parameter_changed.emit(parameter_data.key, slider.value)


func _on_h_slider_value_changed(value: float) -> void:
	parameter_data.default = value
	value_label.text = String.num(value, 2)
	SignalBus.parameter_changed.emit(parameter_data.key, value)

func _on_preset_loaded(preset: PresetData) -> void:
	for p in preset.get_property_list():
		if p.class_name == 'ParameterData' and p.name == parameter_data.key:
			parameter_data = preset[p.name]
			set_parameter_value(parameter_data.default)