extends TaskData
class_name ChronoTaskData

func _init() -> void:
	super()
	type = "ChronoTask"

@export var pairs: Array[String]
@export var hint: String

func to_dictionary() -> Dictionary:
	var dict = super()
	dict["pairs"] = pairs
	dict["hint"] = hint
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super(dict)
	pairs.assign(dict["pairs"])
	hint = dict["hint"]
