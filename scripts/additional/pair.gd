extends Resource
class_name Pair

@export var first_val: String
@export var second_val: String

func to_dictionary() -> Dictionary:
	return {
		"first_val": first_val,
		"second_val":second_val
	}

func from_dictionary(dict: Dictionary) -> void:
	first_val = dict["first_val"]
	second_val = dict["second_val"]
