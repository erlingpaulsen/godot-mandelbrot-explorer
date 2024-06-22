extends Node

signal parameter_ready(parameter_control: ParameterControl)
signal parameter_changed(parameter_key: String, new_value: float)
signal coordinates_updated(top_left: Vector2, bottom_right: Vector2)
signal mouse_coordinates_updated(mouse_pos: Vector2)
signal scale_updated(new_scale: float)
signal preset_saved()
signal preset_loaded(preset: PresetData)
