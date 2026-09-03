extends Node

@export var controller: Controller
@export var test_data: TestData
@export var mainUI: CanvasLayer
@export var quizUI: CanvasLayer
var last_save_path: String
func _ready() -> void:
	var main_data: FileAccess = FileAccess.open("user://main_data.json",FileAccess.READ)
	if main_data == null:
		var new_main_data: FileAccess = FileAccess.open("user://main_data.json",FileAccess.WRITE)
		new_main_data.store_string("")
	else:
		if main_data.get_as_text().length() == 0:
			return
		var main_data_obj = JSON.parse_string(main_data.get_as_text())
		if !main_data_obj:
			return
		if main_data_obj.has("last_save_path"):
			last_save_path = main_data_obj["last_save_path"]

func _on_start_pressed() -> void:
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.filters = PackedStringArray([
        "*.test ; Файл теста"
	])
	dialog.use_native_dialog = true
	dialog.file_selected.connect(_on_dir_selected_load)
	add_child(dialog)
	dialog.current_dir = last_save_path + "/"
	dialog.popup_centered_ratio()

func _on_dir_selected_load(path: String) -> Error:
	test_data.load_from_file(path)
	
	quizUI.visible = true
	mainUI.visible = false
	controller.load_new_data(test_data)
	
	return OK

func return_menu() -> void:
	quizUI.visible = false
	mainUI.visible = true

func _on_creator_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/editor.tscn")
