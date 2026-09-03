extends QuestionTaskDataUI
class_name ImageTaskDataConfiguredUI

@export var data: UIArrayDecSpotConf
var image_task_data_conf: ImageTaskDataConfigured

@export var choose_image: ImageExplorer
@export var main_container: Control
@export var configurator_prefab: PackedScene
@export var choice_counter: SpinBox

func configure_done():
	main_container.visible = true
	data.update_data()

func configure_spot(spot_index: int):
	var configurator: DecSpotConfiguratorConfigured = configurator_prefab.instantiate()
	add_child(configurator)
	main_container.visible = false
	configurator.load_data(image_task_data_conf,test_data,spot_index)
	configurator.done.connect(configure_done)

func load_task_data(new_task_data: TaskData):
	super(new_task_data)
	image_task_data_conf = new_task_data as ImageTaskDataConfigured
	choose_image.load_data(test_data,image_task_data_conf.image_id)
	choose_image.id_updated.connect(image_updated)
	data.ui_data = self
	data.load_data(image_task_data_conf.spots, test_data)
	data.load_data_pair(image_task_data_conf.pairs)
	choice_counter.value = image_task_data_conf.choice_count

func image_updated(image_index: String):
	image_task_data_conf.image_id = image_index


func _on_choice_count_changed(value: float) -> void:
	image_task_data_conf.choice_count = value
