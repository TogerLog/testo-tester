extends Node

class_name Task

@export var points: int = 1
@export var penalty: int = 1
@export var one_shot: bool 
@export var show_everything: bool

func set_view(value: bool) -> void:
	show_everything = value

func set_one_shot(value: bool) -> void:
	one_shot = value

func load_task(task_data: TaskData) -> void:
	points = task_data.points
	penalty = task_data.penalty
	one_shot = task_data.one_shot
	show_everything = task_data.show_everything

@warning_ignore("unused_signal")
signal passed(points: int, silent: bool)
@warning_ignore("unused_signal")
signal failed(points: int, silent: bool)
@warning_ignore("unused_signal")
signal finished()
