extends Task
class_name QuestionTask
@export var question_label: Label 
@export var buttons: Array[SimpleButton]
@export var right_answer: Array[String] = ["Правильно"]

func _ready() -> void:
	update_buttons()

func update_buttons():
	for button in buttons:
		button.answer.connect(get_answer)

func show_answers():
	for button in buttons:
		button.disable(true if right_answer.has(button.text) else false)

func show_needed_answers():
	if show_everything:
		show_answers()
	else:
		for button in buttons:
			button.disabled = true

func load_task(task_data: TaskData) -> void:
	super(task_data)
	var question_data: QuestionTaskData = task_data.duplicate(true) as QuestionTaskData
	question_label.text = question_data.question
	var button_count = min(question_data.choices.size(),buttons.size())
	for i in range(button_count):
		buttons[i].visible = true
		var choice = randi_range(0,question_data.choices.size() - 1)
		buttons[i].set_text(question_data.choices[choice])
		question_data.choices.remove_at(choice)
	right_answer = question_data.right_answers

func get_answer(answer: String, current_button: Node):
	var is_right = right_answer.has(answer)
	current_button.disable(is_right)
	if is_right:
		passed.emit(points)
		show_needed_answers()
		finished.emit()
	else:
		failed.emit(penalty)
		if one_shot:
			show_needed_answers()
			finished.emit()
