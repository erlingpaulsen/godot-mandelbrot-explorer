extends Control

var dragging = false
var current_zoom: float
var current_position: Vector2
var current_uv0: Vector2
var current_uv1: Vector2
var mouse_pos: Vector2
var mouse_outside = false
enum {FILE_DIALOG_LOADING, FILE_DIALOG_SAVING, FILE_DIALOG_NONE}
var file_dialog = FILE_DIALOG_NONE

@export var preset_data: PresetData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Loading data from preset
	material.set_shader_parameter("position", preset_data.position)
	material.set_shader_parameter("offset", preset_data.offset)
	material.set_shader_parameter("zoom", preset_data.zoom)
	# for prop in preset_data.get_property_list():
	# 	if prop.class_name == 'ParameterData':
	# 		print(prop.name, ' ', preset_data[prop.name].default)
	# 		material.set_shader_parameter(prop.name, preset_data[prop.name].default)
	# 		print(prop.name, ' ', preset_data[prop.name].default, ' ', material.get_shader_parameter(prop.name, preset_data[prop.name].default))
	#canvas.material.set_shader_parameter("position", Vector2(0.9, 1.1))
	#canvas.material.set_shader_parameter("zoom", -2.25)
	#canvas.material.set_shader_parameter("position", Vector2(-0.110649, -0.988631))
	#canvas.material.set_shader_parameter("zoom", 1.97775826765936)
	SignalBus.parameter_ready.connect(_on_parameter_ready)
	SignalBus.parameter_changed.connect(_on_parameter_changed)
	_broadcast_scale_and_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_broadcast_scale_and_position()
	update_size(get_parent_control().size - DynamicUI.get_total_margin())

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


func _on_parameter_changed(parameter_key: String, new_value: float) -> void:
	material.set_shader_parameter(parameter_key, new_value)
	preset_data[parameter_key].default = new_value


func _on_file_dialog_file_selected(path: String) -> void:
	if file_dialog == FILE_DIALOG_SAVING:
		# var preset_data_copy = preset_data.duplicate(true)
		# for prop in preset_data_copy.get_property_list():
		# 	if prop.class_name == 'ParameterData':
		# 		preset_data_copy[prop.name].resource_local_to_scene = true
		var err = ResourceSaver.save(preset_data, path)
		if err != OK:
			printerr('Could not save file, error code ', err)
	elif file_dialog == FILE_DIALOG_LOADING:
		pass
	file_dialog = FILE_DIALOG_NONE


func _on_export_button_pressed() -> void:
	file_dialog = FILE_DIALOG_SAVING


func _on_load_button_pressed() -> void:
	file_dialog = FILE_DIALOG_LOADING