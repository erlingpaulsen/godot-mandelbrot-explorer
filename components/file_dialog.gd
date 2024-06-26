extends FileDialog

var filters_tres: PackedStringArray = ['*.tres']
var filters_png: PackedStringArray = ['*.png']


func _on_export_button_pressed() -> void:
	_reset_file_dialog(FileDialog.FILE_MODE_SAVE_FILE, filters_tres)


func _on_load_button_pressed() -> void:
	_reset_file_dialog(FileDialog.FILE_MODE_OPEN_FILE, filters_tres)


func _on_image_button_pressed() -> void:
	_reset_file_dialog(FileDialog.FILE_MODE_SAVE_FILE, filters_png)


func _reset_file_dialog(new_file_mode: FileDialog.FileMode, new_filters: PackedStringArray) -> void:
	file_mode = new_file_mode
	filters = new_filters
	current_file = ''
	show()