extends ChronoTaskDataUI
class_name ChronoTaskDataConfiguredUI

@export var average: SpinBox

func _on_average_value_changed(value: float) -> void:
	var task_data: ChronoTaskDataConfigured = current_task_data as ChronoTaskDataConfigured
	task_data.average = value

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	var task_data: ChronoTaskDataConfigured = current_task_data as ChronoTaskDataConfigured
	average.value = task_data.average
