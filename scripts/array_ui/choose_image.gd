extends Node
class_name ImageExplorer

@export var image: TextureRect
@export var button: MenuButton
@export var test_data: TestData
@export var id: String
@export var file_path: String
@export var last_path: String
@export var include_no_image: bool = false
@export var no_image: Texture2D

@export var images: Dictionary[String, Texture2D]

signal id_updated(image_index: String)

func load_data(new_test_data: TestData, new_index: String) -> void:
	test_data = new_test_data
	images = test_data.image_textures
	if new_index.length() > 0:
		button.text = new_index
		image.texture = images[new_index]
	button.get_popup().index_pressed.connect(popup)
	button.about_to_popup.connect(about_to_popup)

func about_to_popup() -> void:
	var _popup: PopupMenu = button.get_popup()
	_popup.clear()
	for key in images.keys():
		_popup.add_item(key)
		if images[key] != null:
			_popup.set_item_icon(_popup.item_count - 1, images[key])
	if include_no_image:
		_popup.add_item("[БЕЗ ИЗОБРАЖЕНИЯ]")
	_popup.add_item("Новое изображение...")

func update_image(index: String) -> void:
	if images.has(index):
		id_updated.emit(index)
		button.text = index
		image.texture = images[index]

func popup(index: int) -> void:
	if index < images.keys().size():
		var ids = images.keys()
		id = ids[index]
		update_image(id)
	else:
		if include_no_image && index == button.get_popup().item_count - 2:
			id_updated.emit("[БЕЗ ИЗОБРАЖЕНИЯ]")
			button.text = "[БЕЗ ИЗОБРАЖЕНИЯ]"
			image.texture = no_image
		else:
			_on_load_image_pressed()

func _on_load_image_pressed() -> void:
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.filters = PackedStringArray([
        "*.png, *.jpeg, *.jpg, *.webp, *.svg ; Файлы изображения"
	])
	dialog.use_native_dialog = true
	dialog.file_selected.connect(_on_dir_selected_load)
	if last_path.length() > 0:
		dialog.current_path = last_path.get_base_dir()
	add_child(dialog)
	dialog.popup_centered_ratio()

func _on_dir_selected_load(path: String) -> void:
	var new_image = Image.new()
	new_image = Image.load_from_file(path)
	if new_image.is_empty():
		return
	file_path = path
	image.texture = ImageTexture.create_from_image(new_image)
	last_path = path.get_base_dir()
	if test_data.images.has(path.get_file()):
		id = path.get_file() + " " + str(test_data.images.size())
	else:
		id = path.get_file()
	test_data.images.push_back(id)
	test_data.image_textures[id] = image.texture
	update_image(id)
