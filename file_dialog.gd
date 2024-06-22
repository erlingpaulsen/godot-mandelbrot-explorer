extends FileDialog

var filters_tres: PackedStringArray = ['*.tres']
var filters_png: PackedStringArray = ['*.png']

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass




func _on_export_button_pressed() -> void:
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	filters = filters_tres
	show()


func _on_load_button_pressed() -> void:
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	filters = filters_tres
	show()


func _on_image_button_pressed() -> void:
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	filters = filters_png
	show()
