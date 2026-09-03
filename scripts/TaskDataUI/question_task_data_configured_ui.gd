extends TaskDataUI

@export var pairs: UIArrayPair
@export var fake_answers: UIArrayString

@export var choices_counter: SpinBox
@export var question_counter: SpinBox

var question_task_data_conf: QuestionTaskDataConfigured

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	question_task_data_conf = current_task_data as QuestionTaskDataConfigured
	pairs.load_data(question_task_data_conf.pairs)
	fake_answers.load_data(question_task_data_conf.fake_answers)
	choices_counter.value = question_task_data_conf.choices_count
	question_counter.value = question_task_data_conf.question_count
	fake_answers.load_data(question_task_data_conf.fake_answers)


func _on_choices_counter_value_changed(value: float) -> void:
	question_task_data_conf.choices_count = int(value)


func _on_question_counter_value_changed(value: float) -> void:
	question_task_data_conf.question_count = int(value)


func _on_tasks_array_changed(new_data_array: Array[Pair]) -> void:
	question_task_data_conf.pairs = new_data_array.duplicate(true)


func _on_choices_changed(new_data_array: Array[String]) -> void:
	question_task_data_conf.fake_answers = new_data_array.duplicate(true)
