extends SpotTaskData
class_name SpotTaskDataConfigured

@export var questions: Array[Pair]

func _init() -> void:
	super()
	type = "SpotTaskConfigured"

func configured() -> Array[Variant]:
	if !include_in_test:
		return []
		
	var task_array: Array[SpotTaskData]
	
	for question in questions.size():
		var task: SpotTaskData = SpotTaskData.new()
		
		task.one_shot = one_shot
		task.show_everything = show_everything
		task.points = points
		task.penalty = penalty
		
		task.image = image
		
		task.question = questions[question].first_val
		task.spots = spots.duplicate(true)
		task.answer = questions[question].second_val
		
		task_array.push_back(task)
	
	task_array.shuffle()
	
	return task_array

func to_dictionary() -> Dictionary:
	var dict = super()
	dict["questions"] = {}
	for q in range(questions.size()):
		dict["questions"][str(q)] = {}
		dict["questions"][str(q)]["first_val"] = questions[q].first_val
		dict["questions"][str(q)]["second_val"] = questions[q].second_val
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super(dict)
	for key in dict["questions"].keys():
		var pair: Pair = Pair.new()
		pair.first_val = dict["questions"][key]["first_val"]
		pair.second_val = dict["questions"][key]["second_val"]
		questions.push_back(pair)
