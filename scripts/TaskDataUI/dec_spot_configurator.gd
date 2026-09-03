extends ISpotConfigurator
class_name DecSpotConfigurator

@export var scale_x: SpinBox
@export var scale_y: SpinBox
@export var image_explorer: ImageExplorer
var task_data_: ImageTaskData

func load_data(new_task_data: TaskData,new_test_data: TestData, new_spot_id: int):
	loading = true
	task_data_ = new_task_data as ImageTaskData
	test_data = new_test_data
	spot_id = new_spot_id
	spot_link = task_data_.spots[spot_id]
	current_spot = spot_link.duplicate(true)
	main_image.texture = test_data.get_texture(task_data_.image_id)
	finish_loading.call_deferred(main_image)

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
	target_image.set_size(Vector2(smallest_size,smallest_size) / 8)
	positioner.size = displayed_size
	positioner.set_position((main_image.size - displayed_size) / 2)
	
	var cur: DecorativeSpot = current_spot as DecorativeSpot
	image_explorer.load_data(test_data,cur.image_id)
	
	target_image.texture = image_explorer.image.texture
	
	target_image.scale = cur.scale
	target_image.position.x = -target_image.size.x / 2 + current_spot.position.x * positioner.size.x
	target_image.position.y = -target_image.size.y / 2 + current_spot.position.y * positioner.size.y
	
	position_x.value = (target_image.position.x + target_image.size.x / 2) / positioner.size.x
	position_y.value = (target_image.position.y + target_image.size.y / 2) / positioner.size.y
	
	scale_x.value = target_image.scale.x
	scale_y.value = target_image.scale.y
	
	loading = false

func accept_changes():
	done.emit()
	spot_link.position = current_spot.position
	var spot_link_:DecorativeSpot = spot_link as DecorativeSpot
	var current_spot_:DecorativeSpot = current_spot as DecorativeSpot
	spot_link_.scale = current_spot_.scale
	spot_link_.image_id = current_spot_.image_id
	spot_link_.image = current_spot_.image
	queue_free()

func _on_scale_x_value_changed(value: float) -> void:
	target_image.scale.x = value
	var cur: DecorativeSpot = current_spot as DecorativeSpot
	cur.scale.x = value

func _on_scale_y_value_changed(value: float) -> void:
	target_image.scale.y = value
	var cur: DecorativeSpot = current_spot as DecorativeSpot
	cur.scale.y = value

func _on_image_explorer_id_updated(image_index: String) -> void:
	var cur: DecorativeSpot = current_spot as DecorativeSpot
	cur.image_id = image_index
	cur.image = test_data.get_texture(image_index)
	target_image.texture = cur.image
