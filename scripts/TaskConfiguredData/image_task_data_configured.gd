extends ImageTaskData
class_name ImageTaskDataConfigured

@export var pairs: Array[Pair]

@export var choice_count: int = -1

func _init() -> void:
	type = "ImageTaskConfigured"

func configured() -> Array[Variant]:
	if !include_in_test:
		return []
	
	var task_array: Array[ImageTaskData]
	
	if choice_count == -1:
		choice_count = pairs.size()
	
	var spots_buf: Array[ISpot] = spots.duplicate(true)
	
	var pairs_left: Array[Pair] = pairs.duplicate(true)
	
	for question_n in range(pairs.size()):
		var task: ImageTaskData = ImageTaskData.new()
		
		var rand: int = randi_range(0,pairs_left.size() - 1)
		
		var answers_buf: Array[Pair] = pairs.duplicate(true)
		
		task.one_shot = one_shot
		task.show_everything = show_everything
		task.points = points
		task.penalty = penalty
		
		task.question = pairs_left[rand].first_val
		task.spots.push_back(spots_buf[rand])
		task.image = image
		
		task.right_answers.push_back(pairs_left[rand].second_val)
		task.choices.push_back(pairs_left[rand].second_val)
		
		answers_buf.erase(pairs_left[rand])
		pairs_left.remove_at(rand)
		spots_buf.remove_at(rand)
		
		for ch in range(choice_count - 1):
			var _rand: int = randi_range(0,answers_buf.size() - 1)
			task.choices.push_back(answers_buf[_rand].second_val)
			answers_buf.remove_at(_rand)
		
		task_array.push_back(task)
	
	task_array.shuffle()
	
	return task_array

func to_dictionary() -> Dictionary:
	var dict: Dictionary = super()
	dict["choice_count"] = choice_count
	dict["pairs"] = {}
	for pair in range(pairs.size()):
		dict["pairs"][str(pair)] = {
			"first_val": pairs[pair].first_val,
			"second_val": pairs[pair].second_val
		}
	
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super.load_from_dict(dict)
	var pairs_dict = dict["pairs"]
	pairs.clear()
	for key in pairs_dict.keys():
		pairs.push_back(Pair.new()) 
		pairs[-1].first_val = pairs_dict[key]["first_val"]
		pairs[-1].second_val = pairs_dict[key]["second_val"]
	choice_count = dict["choice_count"]
