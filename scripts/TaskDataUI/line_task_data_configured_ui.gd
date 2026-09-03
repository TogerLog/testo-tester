extends LinkTaskDataUI
class_name LinkTaskDataConfiguredUI

@export var average: SpinBox

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	var fixed_task_data: LinkTaskDataConfigured = task_data_ as LinkTaskDataConfigured
	average.value = fixed_task_data.average

func _on_spin_box_value_changed(value: float) -> void:
	var fixed_task_data: LinkTaskDataConfigured = task_data_ as LinkTaskDataConfigured
	fixed_task_data.average = int(value)
