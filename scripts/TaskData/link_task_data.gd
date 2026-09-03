extends TaskData
class_name LinkTaskData

@export var pairs: Array[Pair]
@export var hint: String

func _init() -> void:
	super()
	type = "LineTask"

func to_dictionary() -> Dictionary:
	var dict = super()
	dict["pairs"] = {}
	for pair in range(pairs.size()):
		dict["pairs"][str(pair)] = {}
		dict["pairs"][str(pair)]["first_val"] = pairs[pair].first_val
		dict["pairs"][str(pair)]["second_val"] = pairs[pair].second_val
	dict["hint"] = hint
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super(dict)
	for key in dict["pairs"].keys():
		var pair: Pair = Pair.new()
		pair.first_val = dict["pairs"][key]["first_val"]
		pair.second_val = dict["pairs"][key]["second_val"]
		pairs.push_back(pair)
	hint = dict["hint"]
