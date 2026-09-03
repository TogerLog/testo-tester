extends QuestionTaskDataUI
class_name ImageTaskDataUI

@export var choose_image: ImageExplorer
@export var spots: UIArrayDecSpot
@export var main_container: Control
@export var configurator_prefab: PackedScene
var image_task_data: ImageTaskData

func configure_done():
	main_container.visible = true
	spots.update_data()

func configure_spot(spot_index: int):
	var configurator: DecSpotConfigurator = configurator_prefab.instantiate()
	add_child(configurator)
	main_container.visible = false
	configurator.load_data(image_task_data,test_data,spot_index)
	configurator.done.connect(configure_done)

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	image_task_data = new_task_data as ImageTaskData
	choose_image.load_data(test_data,image_task_data.image_id)
	choose_image.id_updated.connect(image_updated)
	spots.ui_data = self
	spots.load_data(image_task_data.spots, test_data)

func image_updated(image_index: String):
	image_task_data.image_id = image_index
