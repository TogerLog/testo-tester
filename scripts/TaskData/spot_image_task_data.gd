extends TaskData
class_name SpotTaskData

func _init() -> void:
	super()
	type = "SpotTask"

@export var spots: Array[ISpot]
@export var question: String
@export var answer: String
@export var image: Texture2D
@export var image_id: String

func update_images(no_image: Texture2D) -> void:
	image = loaded_images.get(image_id,no_image)

func to_dictionary() -> Dictionary:
	var dict = super()
	needed_images.clear()
	needed_images.push_back(image_id)
	dict["question"] = question
	dict["answer"] = answer
	dict["image_id"] = image_id
	dict["spots"] = {}
	for spot in range(spots.size()):
		var spoter: Spot = spots[spot] as Spot
		dict["spots"][str(spot)] = {}
		dict["spots"][str(spot)]["position"] = {
			"x": spoter.position.x,
			"y": spoter.position.y
		}
		dict["spots"][str(spot)]["scale"] = spoter.scale
		dict["spots"][str(spot)]["answer"] = spoter.answer
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super(dict)
	question = dict["question"]
	answer = dict["answer"]
	image_id = dict.get("image_id", "")
	spots.clear()
	for key in dict["spots"].keys():
		var spot: Spot = Spot.new()
		spot.position.x = dict["spots"][key]["position"]["x"]
		spot.position.y = dict["spots"][key]["position"]["y"]
		spot.scale = dict["spots"][key]["scale"]
		spot.answer = dict["spots"][key]["answer"]
		spots.push_back(spot)
