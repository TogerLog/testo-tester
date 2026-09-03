extends Resource
class_name TaskData

@export var name: String = "Задание"

@export var type: String = "NONE"
@export var points: int = 1
@export var penalty: int = 0

@export var one_shot: bool = true
@export var show_everything: bool = true
@export var include_in_test: bool = true
@export var needed_images: Array[String]
@export var loaded_images: Dictionary[String, Texture2D]

signal task_name_changed(new_name: String)

@warning_ignore("unused_parameter")
func update_images(no_image: Texture2D) -> void:
	return

func set_task_name(new_name: String):
	name = new_name
	task_name_changed.emit(new_name)

func _init() -> void:
	points = 0
	penalty = 0

func configured() -> Array[Variant]:
	if include_in_test:
		return [self]
	return []

func to_dictionary() -> Dictionary:
	return {
		"name": name,
		"type": type,
		"points": points,
		"penalty": penalty,
		"one_shot": one_shot,
		"show_everything": show_everything,
		"include_in_test": include_in_test,
		"needed_images": needed_images
	}

func load_from_dict(dict: Dictionary) -> void:
	name = dict["name"]
	type = dict["type"]
	points = dict["points"]
	penalty = dict["penalty"]
	one_shot=dict["one_shot"]
	show_everything=dict["show_everything"]
	include_in_test=dict["include_in_test"]
	needed_images.assign(dict["needed_images"])
