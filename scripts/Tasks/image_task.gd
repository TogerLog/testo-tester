extends QuestionTask
class_name ImageTask

@export var image: TextureRect
@export var spot_image: PackedScene

func load_task(task_data: TaskData) -> void:
	super(task_data)
	var question_data: ImageTaskData = task_data.duplicate(true) as ImageTaskData
	handle_image.call_deferred(question_data)

func handle_image(image_data: ImageTaskData) -> void:
	image.texture = image_data.image
	
	var big_square: Vector2 = image.size
	var smol_square: Vector2 = image_data.image.get_size()
	
	image.set_size(Vector2(big_square.y / smol_square.y * smol_square.x,image.size.y))
	image.position.x = image.get_parent().size.x / 2 - image.size.x / 2
	var smallest_size: float = min(image.size.x,image.size.y)
	for i in range(image_data.spots.size()):
		var spot: TextureRect = spot_image.instantiate()
		image.add_child.call_deferred(spot)
		spot.texture = image_data.spots[i].image
		spot.size = Vector2(smallest_size,smallest_size ) / 8
		spot.position = image.size * (image_data.spots[i].position - Vector2(0.5,0.5)) - spot.size / 2
		spot.scale = image_data.spots[i].scale
