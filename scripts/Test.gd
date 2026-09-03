extends Resource
class_name TestData

@export var name: String = "Тест"
@export var tasks: Array[TaskData]
@export var points: int = -1
@export var penalty: int = -1
@export var one_shot: bool = false
@export var show_everything: bool = false
@export var use_options: bool = false
@export var use_percent: bool = false
@export var threshold: int = 0
@export var threshold_percent: float = 0.5
@export var max_mistake: int = 3
@export var images: Array[String] 
var image_textures: Dictionary[String,Texture2D]
var no_image: Texture2D = load("res://sprites/no image.png")

func get_texture(id: String) -> Texture2D:
	return image_textures.get(id,no_image)

func load_textures(reader: ZIPReader) -> void:
	image_textures.clear()
	for image_id in images:
		var image_buff: PackedByteArray = reader.read_file(image_id)
		if image_buff != null:
			var image = Image.new()
			var err = image.load_png_from_buffer(image_buff)
			if err != OK:
				return
			image_textures[image_id] = ImageTexture.create_from_image(image)
		else:
			image_textures[image_id] = no_image
	for task in tasks:
		for id in task.needed_images:
			if image_textures.has(id):
				task.loaded_images[id] = image_textures[id]
			else:
				task.loaded_images[id] = no_image
		task.update_images(no_image)

func load_from_dict(dict: Dictionary):
	tasks.clear()
	for task_dict in dict["tasks"].keys():
		var task: TaskData = TaskDataManager.create_task(dict["tasks"][task_dict]["type"])
		task.load_from_dict(dict["tasks"][task_dict])
		tasks.push_back(task)
	points = dict["points"]
	name = dict["name"]
	penalty = dict["penalty"]
	one_shot = dict["one_shot"]
	show_everything = dict["show_everything"]
	use_options = dict["use_options"]
	use_percent = dict["use_percent"]
	threshold = dict["threshold"]
	threshold_percent = dict["threshold_percent"]
	max_mistake = dict["max_mistake"]
	images.assign(dict["images"])

func to_dict():
	var dict_tasks: Dictionary
	for task in range(tasks.size()):
		dict_tasks[str(task)] = tasks[task].to_dictionary()
	return {
		"tasks": dict_tasks,
		"points": points,
		"penalty": penalty,
		"one_shot": one_shot,
		"show_everything": show_everything,
		"use_options": use_options,
		"use_percent": use_percent,
		"threshold": threshold,
		"threshold_percent": threshold_percent,
		"max_mistake": max_mistake,
		"name": name,
		"images": images
	}

func load_from_file(path: String) -> Error:
	var reader = ZIPReader.new()
	var err = reader.open(path)
	if err != OK:
		return err
	var res = reader.read_file("test.json")
	new()
	load_from_string(res.get_string_from_utf8())
	
	load_textures(reader)
	
	reader.close()
	return OK

func save_images(writer: ZIPPacker) -> void:
	for image in image_textures.keys():
		writer.start_file(image)
		var data: PackedByteArray = image_textures[image].get_image().save_png_to_buffer()
		writer.write_file(data)
		writer.close_file()
	return

func load_from_string(json: String) -> void:
	var dict: Dictionary = JSON.parse_string(json)
	load_from_dict(dict)

func save_to_string() -> String:
	var json: String = JSON.stringify(to_dict(), "\t")
	return json
