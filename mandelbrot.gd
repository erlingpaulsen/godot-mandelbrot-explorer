extends Control

var dragging = false
var current_zoom: float
var current_position: Vector2
var mouse_pos: Vector2

@export var canvas_size: Vector2
@export var initial_position: Vector2
@export var offset: Vector2
@export var initial_zoom: float

@export var time_scale = 0.05
@export var palette_scale_modulation = 0.25
@export var palette_scale_modulation_speed = 0.1
@export var palette_scale = 0.75
@export var iteration_effect = 0.5
@export var iteration_effect_modulation = 0.25
@export var iteration_effect_modulation_speed = 0.25
@export var gamma = 1.25
@export var gamma_modulation = 0.5
@export var gamma_modulation_speed = 0.15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = canvas_size
	material.set_shader_parameter("size", size)
	material.set_shader_parameter("position", initial_position)
	material.set_shader_parameter("offset", offset)
	material.set_shader_parameter("zoom", initial_zoom)
	material.set_shader_parameter("time_scale", time_scale)
	material.set_shader_parameter("palette_scale_modulation", palette_scale_modulation)
	material.set_shader_parameter("palette_scale_modulation_speed", palette_scale_modulation_speed)
	material.set_shader_parameter("palette_scale", palette_scale)
	material.set_shader_parameter("iteration_effect", iteration_effect)
	material.set_shader_parameter("iteration_effect_modulation", iteration_effect_modulation)
	material.set_shader_parameter("iteration_effect_modulation_speed", iteration_effect_modulation_speed)
	material.set_shader_parameter("gamma", gamma)
	material.set_shader_parameter("gamma_modulation", gamma_modulation)
	material.set_shader_parameter("gamma_modulation_speed", gamma_modulation_speed)
	#canvas.material.set_shader_parameter("position", Vector2(0.9, 1.1))
	#canvas.material.set_shader_parameter("zoom", -2.25)
	#canvas.material.set_shader_parameter("position", Vector2(-0.110649, -0.988631))
	#canvas.material.set_shader_parameter("zoom", 1.97775826765936)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _input(event):
	current_zoom = material.get_shader_parameter("zoom")
	current_position = material.get_shader_parameter("position")
	
	# Recording mouse position to make zoom go towards mouse pointer
	if event is InputEventMouse:
		mouse_pos = event.position
	
	# Canvas dragging
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Start dragging on click
		if not dragging and event.pressed:
			dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
	
	# Scroll zoom with automatic adjustment of scroll sensitivity and movement towards mouse cursor
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		var step = 0.025 * abs(2.0 - current_zoom)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			step *= -1
		material.set_shader_parameter("zoom", current_zoom + step)
		material.set_shader_parameter("position", current_position - step * mouse_pos / size)

	# Dragging with automatic adjustment of dragging sensitivity
	if event is InputEventMouseMotion and dragging:
		var step = Vector2(1.0 / size.x, 1.0 / size.y) * (2.0 - current_zoom)
		material.set_shader_parameter("position", current_position + event.relative * step)
		

	# Display current zoom and position
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			print('Current zoom: ', current_zoom, ', current pos: ', current_position)

func update_size(new_size: Vector2) -> void:
	size = new_size
	material.set_shader_parameter("size", size)


func _on_parameter_control_time_scale_parameter_changed(parameter_key: String, new_value: float) -> void:
	material.set_shader_parameter(parameter_key, new_value)


func _on_parameter_control_palette_scale_parameter_changed(parameter_key: String, new_value: float) -> void:
	material.set_shader_parameter(parameter_key, new_value)
