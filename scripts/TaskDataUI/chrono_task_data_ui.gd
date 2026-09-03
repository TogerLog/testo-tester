extends TaskDataUI
class_name ChronoTaskDataUI

@export var hint_text: LineEdit
@export var chrono_array: UIArrayString

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	var task_data: ChronoTaskData = new_task_data as ChronoTaskData
	chrono_array.load_data(task_data.pairs)
	hint_text.text = task_data.hint


func _on_hint_text_changed(new_text: String) -> void:
	var task_data: ChronoTaskData = current_task_data as ChronoTaskData
	task_data.hint = new_text


func _on_chronology_array_changed(new_data_array: Array[String]) -> void:
	var task_data: ChronoTaskData = current_task_data as ChronoTaskData
	task_data.pairs = new_data_array
