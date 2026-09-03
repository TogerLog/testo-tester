extends Node

var test_data: TestData

var task_ui_data: Array[TaskData]

var current_task_data: TaskData
var current_task_button: TaskButton

@export var task_button_prefab: PackedScene
@export var task_buttons_parent: Node

@export var ui_parent: Node
@export var delete_button: Button
@export var new_button: MenuButton

@export var task_buttons: Array[TaskButton]

@export var global_settings: PackedScene

var deleting: bool = false 

@export var theme: Theme

var last_save_path: String = "NULL"

var loading: bool = false

func update_poppup_menu():
	var popup: PopupMenu = new_button.get_popup()
	popup.clear()
	var keys = TaskDataManager.type_description.keys()
	for key in keys:
		popup.add_item(TaskDataManager.get_description(key),TaskDataManager.get_type_id(key))

func _ready() -> void:
	update_poppup_menu()
	new_test_data()
	new_button.get_popup().id_pressed.connect(new_button_chosen)
	
	var main_data = FileAccess.open("user://main_data.json",FileAccess.READ)
	if main_data != null:
		var main_data_obj = JSON.parse_string(main_data.get_as_text())
		if main_data_obj:
			last_save_path = main_data_obj["last_save_path"]

func new_button_chosen(id: int):
	create_task(TaskDataManager.get_id_type(id))

func clear_ui():
	for child in ui_parent.get_children():
		child.queue_free()

func choose_task(node: TaskButton):
	if deleting:
		if current_task_button == node:
			clear_ui()
		task_ui_data.remove_at(node.get_index())
		test_data.tasks.remove_at(node.get_index())
		node.queue_free()
		delete_task()
		return
	current_task_button = node
	current_task_data = task_ui_data[current_task_button.get_index()] as TaskData
	load_ui(current_task_data)

func load_ui(task_data: TaskData):
	clear_ui()
	var task_ui: TaskDataUI = TaskDataManager.create_ui_conf(task_data.type)
	task_ui.test_data = test_data
	task_ui.load_task_data(task_data)
	ui_parent.add_child.call_deferred(task_ui)

func on_task_name_changed(new_name: String):
	current_task_button.button.text = new_name

func include_toggle_changed(toggled_on: bool, node: TaskButton):
	if !loading:
		task_ui_data[node.get_index()].include_in_test = toggled_on

func delete_task():
	if !deleting:
		deleting = true
		delete_button.text = "ВЫБЕРИ ЗАДАНИЕ"
		delete_button.modulate = Color.RED
	else:
		delete_button.modulate = Color.WHITE
		deleting = false
		delete_button.text = "Удалить"

func create_task_button(button_name: String) -> TaskButton:
	var task_button: TaskButton = task_button_prefab.instantiate()
	task_buttons_parent.add_child(task_button)
	task_button.choose.connect(choose_task)
	task_button.press.connect(include_toggle_changed)
	task_button.button.text = button_name
	return task_button

func create_task(type: String):
	var task: TaskData = TaskDataManager.create_task(type)
	
	task.task_name_changed.connect(on_task_name_changed)
	
	task_ui_data.push_back(task)
	
	task.name = "Задание " + str(task_ui_data.size())
	create_task_button(task.name)
	test_data.tasks.push_back(task)

func _on_save_pressed() -> void:
	var dialog = FileDialog.new()
	dialog.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
	dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	dialog.filters = PackedStringArray([
        "*.test ; Файл теста"
	])
	if test_data.name != null:
		dialog.current_file = test_data.name + ".test"
	else:
		dialog.current_file = "безымянный.test"
	dialog.set_use_native_dialog(true) ## This is what you want
	dialog.file_selected.connect(_on_dir_selected_save)
	add_child(dialog)
	if last_save_path != "NULL":
		dialog.current_path = last_save_path + "/"
	dialog.popup_centered_ratio()

func _on_dir_selected_save(path: String) -> Error:
	var writer = ZIPPacker.new()
	var err = writer.open(path)
	if err != OK:
		return err
	writer.start_file("test.json")
	writer.write_file(test_data.save_to_string().to_utf8_buffer())
	writer.close_file()
	
	test_data.save_images(writer)
	
	var main_data_obj = {}
	main_data_obj["last_save_path"] = path.get_base_dir()
	last_save_path = path.get_base_dir()
	
	var main_data = FileAccess.open("user://main_data.json",FileAccess.WRITE)
	main_data.store_string(JSON.stringify(main_data_obj,"\t"))
	writer.close()
	return OK

func _on_load_pressed() -> void:
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.filters = PackedStringArray([
        "*.test ; Файл теста"
	])
	dialog.use_native_dialog = true
	dialog.file_selected.connect(_on_dir_selected_load)
	add_child(dialog)
	if last_save_path != "NULL":
		dialog.current_path = last_save_path + "/"
	dialog.popup_centered_ratio()

func _on_dir_selected_load(path: String) -> Error:
	var reader = ZIPReader.new()
	var err = reader.open(path)
	if err != OK:
		return err
	reader.close()
	
	new_test_data()
	
	test_data.load_from_file(path)
	
	loading = true
	var main_data_obj = {}
	main_data_obj["last_save_path"] = path.get_base_dir()
	last_save_path = path.get_base_dir()
	
	var main_data = FileAccess.open("user://main_data.json",FileAccess.WRITE)
	main_data.store_string(JSON.stringify(main_data_obj,"\t"))
	
	for task in test_data.tasks:
		task_ui_data.push_back(task)
		task.task_name_changed.connect(on_task_name_changed)
		var button: TaskButton = create_task_button(task.name)
		button.check_box.button_pressed = task.include_in_test
	loading = false
	return OK

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_options_pressed() -> void:
	clear_ui()
	var node: TestSettingsUI = global_settings.instantiate()
	node.load_data(test_data)
	ui_parent.add_child.call_deferred(node)


func _on_new_pressed() -> void:
	
	var pc = load("res://scripts/OS_specific/PC.gd")
	
	if !OS.has_feature("android") && pc:
		var pc_dialog = pc.create_dialog()
		pc_dialog.title = "Создание нового теста..."
		pc_dialog.dialog_text = "Создать новый тест?\nНесохранённые изменения будут потеряны"
		pc_dialog.confirmed.connect(new_test_data)
		add_child(pc_dialog)
		pc_dialog.show()
	else:
		var dialog = ConfirmationDialog.new()
		dialog.title = "Создание нового теста..."
		dialog.dialog_text = "Создать новый тест?\nНесохранённые изменения будут потеряны"
		dialog.confirmed.connect(new_test_data)
		add_child(dialog)
		dialog.theme = theme
		dialog.popup_centered_ratio()

func new_test_data() -> void:
	clear_ui()
	task_ui_data.clear()
	for button in task_buttons:
		button.queue_free()
	for child in task_buttons_parent.get_children():
		child.queue_free()
	task_buttons.clear()
	test_data = TestData.new()
	test_data.name = "Безымянный тест"
