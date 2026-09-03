extends Control
class_name TestSettingsUI

@export var name_: LineEdit
@export var points_: SpinBox
@export var penalty_: SpinBox
@export var one_shot_: TextureButton
@export var show_everything_: TextureButton
@export var use_options_: TextureButton
@export var use_percent_: TextureButton
@export var threshold_: SpinBox
@export var threshold_percent_: SpinBox # /100
@export var max_mistake_: SpinBox

@export var use_percent_vis: Control
@export var threshold_vis: Control
@export var threshold_percent_vis: Control # /100
@export var max_mistake_vis: Control

@export var test_data: TestData

@export var use_options_disabler: Control

func load_data(new_test_data: TestData):
	test_data = new_test_data
	name_.text = test_data.name
	points_.value = test_data.points
	penalty_.value = test_data.penalty
	one_shot_.button_pressed = test_data.one_shot
	show_everything_.button_pressed = test_data.show_everything
	use_options_.button_pressed = test_data.use_options
	use_percent_.button_pressed = test_data.use_percent
	threshold_.value = test_data.threshold
	threshold_percent_.value = test_data.threshold_percent * 100
	max_mistake_.value = test_data.max_mistake
	update_disabler()
	update_score_sys()

func update_score_sys() -> void:
	use_percent_vis.visible = false
	threshold_vis.visible = false
	threshold_percent_vis.visible = false
	max_mistake_vis.visible = false
	if test_data.points == 0:
		max_mistake_vis.visible = true
		return
	use_percent_vis.visible = true
	if test_data.use_percent:
		threshold_percent_vis.visible = true
	else:
		threshold_vis.visible = true

func _on_points_value_changed(value: float) -> void:
	test_data.points = int(value)
	update_score_sys()

func _on_penalty_value_changed(value: float) -> void:
	test_data.penalty = int(value)

func update_disabler():
	var val: bool = use_options_.button_pressed
	use_options_disabler.visible = val

func _on_use_options_toggled(toggled_on: bool) -> void:
	test_data.use_options = toggled_on
	update_disabler()

func _on_one_shot_toggled(toggled_on: bool) -> void:
	test_data.one_shot = toggled_on

func _on_show_everything_toggled(toggled_on: bool) -> void:
	test_data.show_everything = toggled_on

func _on_percent_toggled(toggled_on: bool) -> void:
	test_data.use_percent = toggled_on
	update_score_sys()

func _on_threshold_value_changed(value: float) -> void:
	test_data.threshold = int(value)
	

func _on_threshold_percent_value_changed(value: float) -> void:
	test_data.threshold_percent = value / 100

func _on_max_mistakes_value_changed(value: float) -> void:
	test_data.max_mistake = int(value)


func _on_name_text_submitted(new_text: String) -> void:
	test_data.name = new_text
