extends ISpotConfigurer
class_name UIElementDecSpot

@export var image_explorer: ImageExplorer
var dec_spot: DecorativeSpot

func load_data(new_num_index: int,new_test_data: TestData, new_spot: ISpot = null, new_index: String = ""):
	spot = new_spot
	dec_spot = new_spot as DecorativeSpot
	image_explorer.load_data(new_test_data,new_index)
	index_label.text = str(new_num_index)

func update():
	image_explorer.update_image(dec_spot.image_id)

func _on_image_explorer_id_updated(image_index: String) -> void:
	dec_spot.image_id = image_index
