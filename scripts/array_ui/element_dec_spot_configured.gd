extends UIElementSpot
class_name UIElementSpotConfigured

@export var pair: Pair
@export var questioner: LineEdit

func load_pair(new_pair: Pair):
	pair = new_pair

func update():
	line_edit.text = spot_button.answer
	questioner.text = pair.first_val

func _on_answer_id_text_changed(new_text: String) -> void:
	spot_button.answer = new_text
	pair.second_val = new_text

func _on_question_text_changed(new_text: String) -> void:
	pair.first_val = new_text
