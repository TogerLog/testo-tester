extends QuestionTaskData
class_name ImageTaskData

func _init() -> void:
	super()
	type = "ImageTask"

@export var image: Texture2D = load("res://sprites/no image.png")
@export var image_id: String

@export var spots: Array[ISpot]

func update_images(no_image: Texture2D) -> void:
	image = loaded_images.get(image_id,no_image)
	for spot in spots:
		spot.image = loaded_images.get(spot.image_id,no_image)

func to_dictionary() -> Dictionary:
	needed_images.clear()
	needed_images.push_back(image_id)
	var spots_dict: Array[Dictionary]
	for spot: DecorativeSpot in spots:
		var spot_dict: Dictionary = {}
		spot_dict["image_id"] = spot.image_id
		spot_dict["position"] = {
		"x": spot.position.x,
		"y": spot.position.y
		}
		spot_dict["size"] = {
		"x": spot.scale.x,
		"y": spot.scale.y
		}
		spots_dict.push_back(spot_dict)
		if !needed_images.has(spot.image_id):
			needed_images.push_back(spot.image_id)
	var dict = super.to_dictionary()
	dict["question"] = question
	dict["right_answers"] = right_answers
	dict["choices"] = choices
	dict["image_id"] = image_id
	dict["spots"] = spots_dict
	return dict

func load_from_dict(dict: Dictionary) -> void:
	super.load_from_dict(dict)
	question = dict.get("question", "")
	image_id = dict.get("image_id", "")
	
	spots.clear()
	
	for spot_dict in dict["spots"]:
		var spot: DecorativeSpot = DecorativeSpot.new()
		spot.image_id = spot_dict["image_id"]
		var position: Dictionary = spot_dict["position"]
		var size: Dictionary = spot_dict["size"]
		spot.position.x = position["x"]
		spot.position.y = position["y"]
		spot.scale.x = size["x"]
		spot.scale.y = size["y"]
		spots.push_back(spot)
	
	if dict.has("right_answers"):
		var typed_array = []
		typed_array = dict.get("right_answers")
		right_answers.assign(typed_array as Array[String])
	if dict.has("choices"): 
		var typed_array = []
		typed_array = dict.get("choices")
		choices.assign(typed_array as Array[String])
