extends TaskData
class_name QuestionTaskData

func _init() -> void:
	super()
	type = "QuestionTask"

@export var question: String

@export var right_answers: Array[String] = []
@export var choices: Array[String] = []

func to_dictionary() -> Dictionary:
	var dict = super.to_dictionary()
	dict["question"] = question
	dict["right_answers"] = right_answers
	dict["choices"] = choices
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super.load_from_dict(dict)
	question = dict.get("question", "")
	if dict.has("right_answers"): 
		var typed_array = []
		typed_array = dict.get("right_answers")
		right_answers.assign(typed_array as Array[String])
	if dict.has("choices"): 
		var typed_array = []
		typed_array = dict.get("choices")
		choices.assign(typed_array as Array[String])
