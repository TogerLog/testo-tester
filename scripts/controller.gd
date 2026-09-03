extends Node
class_name Controller

@export var tasks: Array[TaskData]
@export var test_data: TestData

@export var score: int = 0
@export var taskCounter: int = 0
@export var taskCounterMax: int = 0

@export var right_buzz: AudioStreamPlayer
@export var wrong_buzz: AudioStreamPlayer

@export var current_task_obj: Node

@export var main_label: Label
@export var score_label: Label
@export var task_label: Label

@export var timer: Timer

@export var points: int = -1
@export var penalty: int = -1
@export var shuffle: bool = true

@export var use_options: bool = false
@export var one_shot: bool = true
@export var show_everything: bool = true
@export var max_mistake: int = 3
@export var use_percent: bool = true
@export var threshold: int = 3
@export var threshold_percent: float = 3

func start() -> void:
	update_score()
	taskCounterMax = tasks.size() - 1
	iterate_tasks()

func load_new_data(new_test_data: TestData):
	score = 0
	for child in get_children():
		if child.get_index() > 2:
			child.queue_free()
	test_data = new_test_data
	
	tasks.clear()
	
	for task_dat in test_data.tasks:
		var arr = task_dat.configured()
		for task in arr:
			tasks.push_back(task)
	
	if shuffle:
		tasks.shuffle()
	
	var end_task_obj = TaskData.new()
	end_task_obj.type = "EndTask"
	tasks.push_back(end_task_obj)
	
	points = test_data.points
	penalty = test_data.penalty
	one_shot = test_data.one_shot
	show_everything = test_data.show_everything
	use_options = test_data.use_options
	
	max_mistake = test_data.max_mistake
	threshold = test_data.threshold
	threshold_percent = test_data.threshold_percent
	use_percent = test_data.use_percent
	
	taskCounter = 0
	
	start()

func iterate_tasks() -> void:
	update_score()
	
	taskCounter += 1
	task_label.text = str(taskCounter) + "/" + str(taskCounterMax)
	if taskCounter > taskCounterMax:
		task_label.text = ""
		score_label.text = ""
	
	var current_task: TaskData = tasks[taskCounter - 1]
	var type: String = tasks[taskCounter - 1].type
	var task_obj: Task = TaskDataManager.create_task_ui(type) as Task
	main_label.text = TaskDataManager.get_label(type)
	
	add_child(task_obj)
	
	if points > -1:
		current_task.points = points
	if penalty > -1:
		current_task.penalty = penalty
	
	if use_options:
		current_task.one_shot = one_shot
		current_task.show_everything = show_everything
	
	current_task_obj = task_obj
	current_task_obj.passed.connect(on_passed_task)
	current_task_obj.finished.connect(on_finished_task)
	current_task_obj.failed.connect(on_failed_task)
	current_task_obj.load_task(current_task)

func on_passed_task(new_points: int, silent: bool = false) -> void:
	score += new_points
	if !silent:
		right_buzz.play()
	update_score()

func on_failed_task(new_points: int, silent: bool = false) -> void:
	score -= new_points
	if !silent:
		wrong_buzz.play()
	update_score()

func on_finished_task() -> void:
	end_task()

func update_score() -> void:
	if points == 0 && penalty != 0:
		score_label.text = "Ошибок " + str(-score)
	else:
		score_label.text = "Счёт " + str(score)

func end_task() -> void:
	update_score()
	current_task_obj.finished.disconnect(on_finished_task)
	current_task_obj.failed.disconnect(on_failed_task)
	timer.start()

func _on_break_ended() -> void:
	if current_task_obj:
		current_task_obj.queue_free()
	iterate_tasks()
