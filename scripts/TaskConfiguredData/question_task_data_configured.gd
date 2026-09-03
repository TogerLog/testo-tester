extends QuestionTaskData
class_name QuestionTaskDataConfigured

@export var pairs: Array[Pair]
@export var fake_answers: Array[String]

@export var choices_count: int = 8
@export var question_count: int = 4

func _init() -> void:
	type = "QuestionTaskConfigured"

func configured() -> Array[Variant]:
	if !include_in_test:
		return []
	var task_array: Array[QuestionTaskData]
	
	var questions: Array[String]
	var answers: Array[String]
	
	for n in range(pairs.size()):
		questions.push_back(pairs[n].first_val)
		answers.push_back(pairs[n].second_val)
	
	for i in range(min(pairs.size(), question_count)):
		var task: QuestionTaskData = QuestionTaskData.new()
		task.one_shot = one_shot
		task.show_everything = show_everything
		task.question = questions[i]
		var answers_buf: Array[String] = answers.duplicate(true)
		task.choices.clear()
		task.right_answers.push_back(answers[i])
		task.choices.push_back(answers[i])
		task.penalty = penalty
		task.points = points
		answers_buf.erase(answers[i])
		answers_buf.append_array(fake_answers)
		for j in range(min(answers_buf.size(), choices_count - 1)):
			var rand = randi_range(0,answers_buf.size() - 1)
			task.choices.push_back(answers_buf[rand])
			answers_buf.remove_at(rand)
		task.choices.shuffle()
		task_array.push_back(task)
	task_array.shuffle()
	return task_array

func to_dictionary() -> Dictionary:
	var dict: Dictionary = super.to_dictionary()
	dict["pairs"] = {}
	for pair_id in range(pairs.size()):
		dict["pairs"][str(pair_id)] = {}
		dict["pairs"][str(pair_id)]["first_val"] = pairs[pair_id].first_val
		dict["pairs"][str(pair_id)]["second_val"] = pairs[pair_id].second_val
	dict["fake_answers"] = fake_answers
	dict["choices_count"] = choices_count
	dict["question_count"] = question_count
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super.load_from_dict(dict)
	
	pairs.clear()
	for pair_id in dict["pairs"].keys():
		pairs.push_back(Pair.new())
		pairs[int(pair_id)].first_val = dict["pairs"][pair_id]["first_val"]
		pairs[int(pair_id)].second_val = dict["pairs"][pair_id]["second_val"]
	
	question = dict.get("question", "")
	fake_answers.assign(dict.get("fake_answers", []))
	
	question_count = dict["question_count"]
	choices_count = dict["choices_count"]
	print_debug(choices_count)
	print_debug(question_count)
