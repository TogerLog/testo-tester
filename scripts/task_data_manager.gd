extends Node

var type_constructors: Dictionary[String,Callable]
@export var type_conf_constructors: Dictionary[String,PackedScene]
@export var type_task_constructors: Dictionary[String,PackedScene]
@export var type_label: Dictionary[String, String]
@export var type_description: Dictionary[String, String]
@export var type_id: Array[String]

func _init() -> void:
	register_types()

func register_types():
	add_type("NONE",TaskData.new)
	add_type("QuestionTask",QuestionTaskData.new)
	add_type("QuestionTaskConfigured",QuestionTaskDataConfigured.new)
	add_type("LineTask",LinkTaskData.new)
	add_type("LineTaskConfigured",LinkTaskDataConfigured.new)
	add_type("ImageTask",ImageTaskData.new)
	add_type("ImageTaskConfigured",ImageTaskDataConfigured.new)
	add_type("SpotTask",SpotTaskData.new)
	add_type("SpotTaskConfigured",SpotTaskDataConfigured.new)
	add_type("ChronoTask",ChronoTaskData.new)
	add_type("ChronoTaskConfigured",ChronoTaskDataConfigured.new)

func get_id_type(id: int) -> String:
	return type_id[id]

func get_type_id(type: String) -> int:
	for _type in range(type_id.size()):
		if type_id[_type] == type:
			return _type
	push_error("couldn't find needed type id")
	return -1

func get_description(type: String):
	if type_description.has(type):
		return type_description[type]
	return type_description["NONE"]

func get_label(type: String):
	if type_label.has(type):
		return type_label[type]
	return type_label["NONE"]

func add_type(type: String, function: Callable):
	type_constructors[type] = function

func can_create_ui_conf(type: String) -> bool:
	return type_conf_constructors.has(type)

func create_task(type: String) -> TaskData:
	if !type_constructors.has(type):
		return type_constructors["NONE"].call()
	return type_constructors[type].call()

func create_ui_conf(type: String) -> TaskDataUI:
	if !type_conf_constructors.has(type):
		return type_conf_constructors["NONE"].instantiate()
	return type_conf_constructors[type].instantiate()

func create_task_ui(type: String) -> Task:
	if !type_task_constructors.has(type):
		return type_task_constructors["NONE"].instantiate()
	return type_task_constructors[type].instantiate()
