extends ISpotConfigurer
class_name UIElementSpot

@export var line_edit: LineEdit
var spot_button: Spot

func load_data(new_num_index: int,new_test_data: TestData, new_spot: ISpot = null, new_index: String = ""):
	spot = new_spot
	spot_button = new_spot as Spot
	line_edit.text = spot_button.answer
	index_label.text = str(new_num_index)

func update():
	line_edit.text = spot_button.answer

func _on_answer_id_text_changed(new_text: String) -> void:
	spot_button.answer = new_text
