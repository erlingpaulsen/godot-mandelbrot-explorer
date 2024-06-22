class_name ParameterData
extends Resource

@export var name: String
@export var key: String
@export var value_range: Vector2
@export var step: float
@export var default: float

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(new_name = 'default', new_key = 'default', new_value_range = Vector2(0, 1), new_step = 0.1, new_default = 0):
	name = new_name
	key = new_key
	value_range = new_value_range
	step = new_step
	default = new_default
