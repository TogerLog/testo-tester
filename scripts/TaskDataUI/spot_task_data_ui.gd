extends TaskDataUI
class_name SpotTaskDataUI

@export var choose_image: ImageExplorer
@export var questioner: TextEdit
@export var spots: UIArraySpots
@export var main_container: Control
@export var configurator_prefab: PackedScene
var spot_task_data: SpotTaskData

func configure_done():
	main_container.visible = true
	spots.update_data()

func configure_spot(spot_index: int):
	var configurator: SpotConfigurator = configurator_prefab.instantiate()
	add_child(configurator)
	main_container.visible = false
	configurator.load_data(spot_task_data,test_data,spot_index)
	configurator.done.connect(configure_done)

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	spot_task_data = new_task_data as SpotTaskData
	choose_image.load_data(test_data,spot_task_data.image_id)
	choose_image.id_updated.connect(image_updated)
	spots.ui_data = self
	spots.load_data(spot_task_data.spots, test_data)

func image_updated(image_index: String):
	spot_task_data.image_id = image_index


func _on_question_text_changed() -> void:
	spot_task_data.question = questioner.text


func _on_answer_text_changed(new_text: String) -> void:
	spot_task_data.answer = new_text
