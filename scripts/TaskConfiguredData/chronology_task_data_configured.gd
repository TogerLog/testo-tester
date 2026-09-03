extends ChronoTaskData
class_name ChronoTaskDataConfigured

@export var average: int = 4
@export var pair_count: Array[int] 

func _init() -> void:
	super()
	type = "ChronoTaskConfigured"

func distribute() -> bool:
	if average == -1 or average > 6:
		average = 4
	var pairs_count: int = pairs.size()
	
	if pairs_count == 0:
		return false
	
	var resizer: int = max(1,round(pairs_count / float(average)))
	
	@warning_ignore("integer_division")
	var base = pairs_count / resizer
	var remainder = pairs_count % resizer
	
	pair_count.resize(resizer)
	for i in range(resizer):
		if i < remainder:
			pair_count[i] = base + 1
		else:
			pair_count[i] = base
	return true

func configured() -> Array[Variant]:
	if !include_in_test or !distribute():
		return []
	
	var task_array: Array[ChronoTaskData]
	
	for task_num in range(pair_count.size()):
		var task: ChronoTaskData = ChronoTaskData.new()
		
		task.one_shot = one_shot
		task.show_everything = show_everything
		task.points = points
		task.penalty = penalty
		
		task.hint = hint
		
		task_array.push_back(task)
	
	var pairs_dup: Array[String] = pairs.duplicate(true)
	
	var result_task_array: Array[ChronoTaskData]
	
	for pair in pairs_dup:
		var which_task = randi_range(0,task_array.size() - 1)
		task_array[which_task].pairs.push_back(pair)
		pair_count[which_task] -= 1
		if pair_count[which_task] == 0:
			result_task_array.push_back(task_array[which_task])
			pair_count.remove_at(which_task)
			task_array.remove_at(which_task)
	
	result_task_array.shuffle()
	
	return result_task_array

func to_dictionary() -> Dictionary:
	var dict = super()
	dict["average"] = average
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super(dict)
	average = dict["average"]
