extends LinkTaskData
class_name LinkTaskDataConfigured

@export var average: int = 4
@export var pair_count: Array[int] 

func _init() -> void:
	super()
	type = "LineTaskConfigured"

func distribute() -> bool:
	if average == -1 or average > 5:
		average = 3
	var pairs_count: int = pairs.size()
	
	if pairs_count == 0:
		return false
	
	var resizer: int = max(1,round(pairs_count / float(average)))
	
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
	
	var task_array: Array[LinkTaskData]
	
	var pairs_dup: Array[Pair] = pairs.duplicate(true)
	
	for task_num in range(pair_count.size()):
		var task: LinkTaskData = LinkTaskData.new()
		
		task.one_shot = one_shot
		task.show_everything = show_everything
		task.points = points
		task.penalty = penalty
		
		task.hint = hint
		for pair in range(pair_count[task_num]):
			var rand = randi_range(0,pairs_dup.size() - 1)
			task.pairs.push_back(pairs_dup[rand])
			pairs_dup.remove_at(rand)
		task_array.push_back(task)
	
	task_array.shuffle()
	
	return task_array

func to_dictionary() -> Dictionary:
	var dict = super()
	dict["average"] = average
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super(dict)
	average = dict["average"]
