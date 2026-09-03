extends ISpotConfigurer
class_name UIElementDecSpotConf

@export var pairer: UIArrayElementPair
@export var pair: Pair 

@export var image_explorer: ImageExplorer 
var dec_spot: DecorativeSpot

func load_data(new_num_index: int,new_test_data: TestData, new_spot: ISpot = null, new_index: String = ""):
	spot = new_spot
	dec_spot = new_spot as DecorativeSpot
	index_label.text = str(new_num_index)
	image_explorer.load_data(new_test_data,new_index)

func load_data_pair(new_pair: Pair):
	pair = new_pair
	pairer.first_node.text = pair.first_val
	pairer.second_node.text = pair.second_val

func update():
	image_explorer.update_image(dec_spot.image_id)
	pairer.first_node.text = pair.first_val
	pairer.second_node.text = pair.second_val

func _on_question_text_changed(new_text: String) -> void:
	pair.first_val = new_text


func _on_answer_text_changed(new_text: String) -> void:
	pair.second_val = new_text


func _on_image_explorer_id_updated(image_index: String) -> void:
	dec_spot.image_id = image_index
