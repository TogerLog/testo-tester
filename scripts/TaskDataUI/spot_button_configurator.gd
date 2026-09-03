extends ISpotConfigurator
class_name SpotConfigurator

@export var scaler: SpinBox
@export var answerer: LineEdit
@export var task_data_: SpotTaskData

func finish_loading(texture_rect: TextureRect) -> void:
	var result: Vector2 = Vector2(0,0)
	var texture_size: Vector2 = texture_rect.texture.get_size()
	var rect_size: Vector2 = texture_rect.size
	var aspect: float = texture_size.x / texture_size.y
	if (rect_size.x / rect_size.y) > aspect:
		result.y = rect_size.y
		result.x = rect_size.y * aspect
	else:
		result.x = rect_size.x
		result.y = rect_size.x / aspect
	var displayed_size: Vector2 = result
	var smallest_size: float = min(result.x,result.y)
	target_image.set_size(Vector2(smallest_size,smallest_size) / 10)
	positioner.size = displayed_size
	positioner.set_position((main_image.size - displayed_size) / 2)
	
	var cur: Spot = current_spot as Spot
	
	target_image.scale = Vector2.ONE * cur.scale
	target_image.position.x = -target_image.size.x / 2 + current_spot.position.x * positioner.size.x
	target_image.position.y = -target_image.size.y / 2 + current_spot.position.y * positioner.size.y
	
	position_x.value = (target_image.position.x + target_image.size.x / 2) / positioner.size.x
	position_y.value = (target_image.position.y + target_image.size.y / 2) / positioner.size.y
	
	scaler.value = target_image.scale.x
	
	loading = false

func load_data(new_task_data: TaskData,new_test_data: TestData, new_spot_id: int):
	loading = true
	task_data_ = new_task_data as SpotTaskData
	test_data = new_test_data
	spot_id = new_spot_id
	spot_link = task_data_.spots[spot_id]
	current_spot = spot_link.duplicate(true)
	answerer.text = task_data_.spots[new_spot_id].answer 
	main_image.texture = test_data.get_texture(task_data_.image_id)
	finish_loading.call_deferred(main_image)

func accept_changes():
	done.emit()
	spot_link.position = current_spot.position
	var spot_link_: Spot = spot_link as Spot
	var current_spot_:Spot = current_spot as Spot
	spot_link_.scale = current_spot_.scale
	spot_link_.answer = current_spot_.answer
	queue_free()

func _on_scale_value_changed(value: float) -> void:
	var current_spot_:Spot = current_spot as Spot
	current_spot_.scale = value
	target_image.scale = Vector2.ONE * value

func _on_answer_text_changed(new_text: String) -> void:
	var current_spot_:Spot = current_spot as Spot
	current_spot_.answer = new_text
