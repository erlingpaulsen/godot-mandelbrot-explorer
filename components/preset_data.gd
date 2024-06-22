class_name PresetData
extends Resource

@export var position: Vector2
@export var offset: Vector2
@export var zoom: float
@export var palette_phase_r: ParameterData
@export var palette_phase_g: ParameterData
@export var palette_phase_b: ParameterData
@export var palette_cycle_speed: ParameterData
@export var distance_effect: ParameterData
@export var distance_effect_mod: ParameterData
@export var distance_effect_mod_speed: ParameterData
@export var iteration_effect: ParameterData
@export var iteration_effect_mod: ParameterData
@export var iteration_effect_mod_speed: ParameterData
@export var gamma: ParameterData
@export var gamma_mod: ParameterData
@export var gamma_mod_speed: ParameterData

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_position = Vector2.ZERO, new_offset = Vector2.ZERO, new_zoom = 0, 
		new_palette_phase_r = ParameterData.new(),
		new_palette_phase_g = ParameterData.new(),
		new_palette_phase_b = ParameterData.new(),
		new_palette_cycle_speed = ParameterData.new(),
		new_distance_effect = ParameterData.new(),
		new_distance_effect_mod = ParameterData.new(),
		new_distance_effect_mod_speed = ParameterData.new(),
		new_iteration_effect = ParameterData.new(),
		new_iteration_effect_mod = ParameterData.new(),
		new_iteration_effect_mod_speed = ParameterData.new(),
		new_gamma = ParameterData.new(),
		new_gamma_mod = ParameterData.new(),
		new_gamma_mod_speed = ParameterData.new()
		):
	position = new_position
	offset = new_offset
	zoom = new_zoom
	palette_phase_r = new_palette_phase_r
	palette_phase_g = new_palette_phase_g
	palette_phase_b = new_palette_phase_b
	palette_cycle_speed = new_palette_cycle_speed
	distance_effect = new_distance_effect
	distance_effect_mod = new_distance_effect_mod
	distance_effect_mod_speed = new_distance_effect_mod_speed
	iteration_effect = new_iteration_effect
	iteration_effect_mod = new_iteration_effect_mod
	iteration_effect_mod_speed = new_iteration_effect_mod_speed
	gamma = new_gamma
	gamma_mod = new_gamma_mod
	gamma_mod_speed = new_gamma_mod_speed
