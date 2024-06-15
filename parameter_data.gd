class_name ParameterData
extends Resource

@export var name: String
@export var key: String
@export var range: Vector2
@export var step: float
@export var default: float

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(name = 'default', key = 'default', range = Vector2(0, 1), step = 0.1, default = 0):
	self.name = name
	self.key = key
	self.range = range
	self.step = step
	self.default = default
