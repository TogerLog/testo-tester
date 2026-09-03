extends SpotConfigurator
class_name SpotConfiguratorConfigured

@export var line_edit: LineEdit
@export var curr_pair: Pair
@export var link_pair: Pair
@export var _task_data: SpotTaskDataConfigured

func load_data(new_task_data: TaskData,new_test_data: TestData, new_spot_id: int):
	loading = true
	_task_data = new_task_data as SpotTaskDataConfigured
	test_data = new_test_data
	spot_id = new_spot_id
	spot_link = _task_data.spots[spot_id]
	current_spot = spot_link.duplicate(true)
	answerer.text = _task_data.spots[new_spot_id].answer
	curr_pair = _task_data.questions[new_spot_id].duplicate(true)
	link_pair = _task_data.questions[new_spot_id]
	line_edit.text = curr_pair.first_val
	main_image.texture = test_data.get_texture(_task_data.image_id)
	finish_loading.call_deferred(main_image)

func accept_changes():
	done.emit()
	spot_link.position = current_spot.position
	var spot_link_: Spot = spot_link as Spot
	var current_spot_:Spot = current_spot as Spot
	spot_link_.scale = current_spot_.scale
	spot_link_.answer = current_spot_.answer
	
	link_pair.first_val = curr_pair.first_val
	link_pair.second_val = curr_pair.second_val
	
	queue_free()

func _on_answer_text_changed(new_text: String) -> void:
	var current_spot_:Spot = current_spot as Spot
	current_spot_.answer = new_text
	curr_pair.second_val = new_text

func _on_question_text_changed(new_text: String) -> void:
	curr_pair.first_val = new_text
