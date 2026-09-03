extends TaskDataUI
class_name LinkTaskDataUI

@export var pairs_array: UIArrayPair
@export var hint_text: LineEdit
var task_data_: LinkTaskData

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	task_data_ = new_task_data as LinkTaskData
	pairs_array.load_data(task_data_.pairs)
	hint_text.text = task_data_.hint


func _on_hint_text_changed(new_text: String) -> void:
	task_data_.hint = new_text


func _on_pairs_array_changed(new_data_array: Array[Pair]) -> void:
	task_data_.pairs = new_data_array
