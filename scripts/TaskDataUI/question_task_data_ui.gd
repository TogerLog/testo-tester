extends TaskDataUI
class_name QuestionTaskDataUI

@export var questioner: TextEdit
@export var right_answers: UIArrayString
@export var choices: UIArrayString

var question_task_data: QuestionTaskData


func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	question_task_data = current_task_data as QuestionTaskData
	if questioner != null:
		questioner.text = question_task_data.question
		right_answers.load_data(question_task_data.right_answers)
		choices.load_data(question_task_data.choices)

func _on_question_text_changed() -> void:
	question_task_data.question = questioner.text

func _on_right_answers_changed(new_data_array: Array[String]) -> void:
	question_task_data.right_answers = new_data_array.duplicate(true)

func _on_choices_changed(new_data_array: Array[String]) -> void:
	question_task_data.choices = new_data_array.duplicate(true)
