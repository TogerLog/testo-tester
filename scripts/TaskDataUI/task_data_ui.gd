extends Control
class_name TaskDataUI

@export var points_spin_box: SpinBox
@export var penalty_spin_box: SpinBox
@export var one_shot_toggle: TextureButton
@export var show_everything_toggle: TextureButton
@export var name_text_line: LineEdit

var current_task_data: TaskData
var test_data: TestData

func load_task_data(new_task_data: TaskData):
	current_task_data = new_task_data
	points_spin_box.value = current_task_data.points
	penalty_spin_box.value = current_task_data.penalty
	one_shot_toggle.button_pressed = current_task_data.one_shot
	show_everything_toggle.button_pressed = current_task_data.show_everything
	name_text_line.text = current_task_data.name

func _on_points_value_changed(value: float) -> void:
	current_task_data.points = int(value)

func _on_penalty_value_changed(value: float) -> void:
	current_task_data.penalty = int(value)

func _on_one_shot_toggled(toggled_on: bool) -> void:
	current_task_data.one_shot = toggled_on 

func _on_show_everything_toggled(toggled_on: bool) -> void:
	current_task_data.show_everything = toggled_on

func _on_name_submitted(new_text: String) -> void:
	current_task_data.set_task_name(new_text)
