extends Control
class_name ISpotConfigurator

@export var task_data: TaskData
@export var test_data: TestData
@export var spot_id: int

@export var main_image: TextureRect
@export var target_image: TextureRect

var is_pressed: bool = false
var loading: bool = false

@export var current_spot: ISpot
@export var spot_link: ISpot

@export var positioner: Button

@export var position_x: SpinBox
@export var position_y: SpinBox

signal done()

func on_positioner_down() -> void:
	is_pressed = true

func on_positioner_up() -> void:
	is_pressed = false


func _process(_delta: float) -> void:
	if is_pressed:
		var target_pos = get_global_mouse_position() - target_image.size / 2 * target_image.scale
		target_pos.x = clamp(target_pos.x,positioner.global_position.x - target_image.size.x / 2 * target_image.scale.x,positioner.global_position.x + positioner.size.x - target_image.size.x / 2 * target_image.scale.x)
		target_pos.y = clamp(target_pos.y,positioner.global_position.y - target_image.size.y / 2 * target_image.scale.y,positioner.global_position.y + positioner.size.y - target_image.size.y / 2 * target_image.scale.y)
		target_image.global_position = target_pos
		position_x.value = (target_image.position.x + target_image.size.x / 2) / positioner.size.x
		position_y.value = (target_image.position.y + target_image.size.y / 2) / positioner.size.y
		current_spot.position.y = position_y.value
		current_spot.position.x = position_x.value


func _on_position_y_changed(value: float) -> void:
	if is_pressed or loading:
		return
	target_image.position.y = - target_image.size.y / 2 + positioner.size.y * value
	current_spot.position.y = value

func _on_position_x_changed(value: float) -> void:
	if is_pressed or loading:
		return
	target_image.position.x = - target_image.size.x / 2 + positioner.size.x * value
	current_spot.position.x = value


@warning_ignore("unused_parameter")
func finish_loading(texture_rect: TextureRect) -> void:
	return

@warning_ignore("unused_parameter")
func load_data(new_task_data: TaskData,new_test_data: TestData, new_spot_id: int):
	return

func cancel():
	done.emit()
	queue_free()

func accept_changes():
	done.emit()
	spot_link.position = current_spot.position
	queue_free()
