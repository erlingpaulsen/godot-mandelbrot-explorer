extends Control

var dragging = false
var current_zoom: float
var current_position: Vector2
var current_uv0: Vector2
var current_uv1: Vector2
var mouse_pos: Vector2
var mouse_outside = false
enum {FILE_DIALOG_LOAD_PRESET, FILE_DIALOG_SAVE_PRESET, FILE_DIALOG_SAVE_IMAGE, FILE_DIALOG_NONE}
var file_dialog = FILE_DIALOG_NONE

@export var preset_data: PresetData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Loading data from preset
	material.set_shader_parameter("position", preset_data.position)
	material.set_shader_parameter("offset", preset_data.offset)
	material.set_shader_parameter("zoom", preset_data.zoom)
	SignalBus.parameter_ready.connect(_on_parameter_ready)
	SignalBus.parameter_changed.connect(_on_parameter_changed)
	SignalBus.preset_loaded.connect(_on_preset_loaded)
	_broadcast_scale_and_position()
	print_debug('Preset loaded and Mandelbrot initialized')
	print_debug('Preset data: ', preset_data)
	print_debug('Shader: ', material.shader)
	print_debug('Shader mode: ', material.shader.get_mode())
	#print_debug('Shader uniforms: ', material.shader.get_shader_uniform_list())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	_broadcast_scale_and_position()
	update_size(get_parent().get_parent().size)# - DynamicUI.get_total_margin())


func _input(event):
	current_zoom = material.get_shader_parameter("zoom")
	current_position = material.get_shader_parameter("position")
	
	# Recording mouse position to make zoom go towards mouse pointer
	if event is InputEventMouse:
		mouse_pos = event.position
		if mouse_pos.x > size.x or mouse_pos.y > size.y:
			mouse_outside = true
		else:
			mouse_outside = false
			var local_mouse_coordinates = (2.0 - current_zoom) * (mouse_pos / size.y) - (current_position + preset_data.offset)
			SignalBus.mouse_coordinates_updated.emit(local_mouse_coordinates)
			
	# Canvas dragging
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not mouse_outside:
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
		preset_data.zoom = current_zoom + step
		preset_data.position = current_position - step * mouse_pos / size
		material.set_shader_parameter("zoom", preset_data.zoom)
		material.set_shader_parameter("position", preset_data.position)


	# Dragging with automatic adjustment of dragging sensitivity
	if event is InputEventMouseMotion and dragging:
		var step = Vector2(1.0 / size.x, 1.0 / size.y) * (2.0 - current_zoom)
		preset_data.position = current_position + event.relative * step
		material.set_shader_parameter("position", preset_data.position)


func _broadcast_scale_and_position() -> void:
	var current_scale = 2.0 - current_zoom;
	var aspect_ratio = size / size.y;
	var position_corr = current_position + preset_data.offset;
	current_uv0 = Vector2(1, -1) * (current_scale * Vector2(0, 0) * aspect_ratio - position_corr)
	current_uv1 = Vector2(1, -1) * (current_scale * Vector2(1, 1) * aspect_ratio - position_corr)
	SignalBus.coordinates_updated.emit(current_uv0, current_uv1)
	SignalBus.scale_updated.emit(current_scale)

func update_size(new_size: Vector2) -> void:
	size = new_size
	material.set_shader_parameter("size", size)


func _on_parameter_ready(parameter_control: ParameterControl) -> void:
	parameter_control.parameter_data = preset_data[parameter_control.parameter_data.key]
	parameter_control.set_parameter_value(parameter_control.parameter_data.default)
	print_debug('Parameter ready ', parameter_control.parameter_data.key)


func _on_parameter_changed(parameter_key: String, new_value: float) -> void:
	material.set_shader_parameter(parameter_key, new_value)
	preset_data[parameter_key].default = new_value
	print_debug('Shader uniform ', parameter_key, ' set to ', new_value)


func _on_preset_loaded(preset: PresetData) -> void:
	preset_data = preset
	material.set_shader_parameter("position", preset_data.position)
	material.set_shader_parameter("offset", preset_data.offset)
	material.set_shader_parameter("zoom", preset_data.zoom)


func _on_file_dialog_file_selected(path: String) -> void:
	if file_dialog == FILE_DIALOG_SAVE_PRESET:
		var err = ResourceSaver.save(preset_data, path)
		if err != OK:
			printerr('Could not save file, error code ', err)
	elif file_dialog == FILE_DIALOG_LOAD_PRESET:
		var loaded_preset = ResourceLoader.load(path)
		SignalBus.preset_loaded.emit(loaded_preset)
	elif file_dialog == FILE_DIALOG_SAVE_IMAGE:
		var err = get_viewport().get_texture().get_image().save_png(path)
		if err != OK:
			printerr('Could not save file, error code ', err)
	file_dialog = FILE_DIALOG_NONE


func _on_export_button_pressed() -> void:
	file_dialog = FILE_DIALOG_SAVE_PRESET


func _on_load_button_pressed() -> void:
	file_dialog = FILE_DIALOG_LOAD_PRESET


func _on_image_button_pressed() -> void:
	file_dialog = FILE_DIALOG_SAVE_IMAGE
