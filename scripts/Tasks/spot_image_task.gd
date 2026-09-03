extends Task
class_name SpotTask

@export var image: TextureRect
@export var label: Label
@export var spot_button: PackedScene
@export var spots: Array[TextureButton]
@export var spot_data: Array[ISpot]
@export var right_answer: String

@export var spot_correct: Texture2D
@export var spot_failed: Texture2D

func wrong(index: int):
	failed.emit(penalty)
	spots[index].texture_disabled = spot_failed
	spots[index].disabled = true
	if one_shot:
		show_answers()
		finished.emit()

func connect_spot(index: int):
	if (spot_data[index] as Spot).answer == right_answer:
		spots[index].pressed.connect(right.bind(index))
	else:
		spots[index].pressed.connect(wrong.bind(index))

func texture_spot(index: int):
	if (spot_data[index] as Spot).answer == right_answer:
		spots[index].texture_disabled = spot_correct
	else:
		spots[index].texture_disabled = spot_failed

func correct_spot(index: int):
	spots[index].position = image.size * ((spot_data[index] as Spot).position - Vector2(0.5,0.5)) - spots[index].size / 2
	spots[index].scale = Vector2.ONE * (spot_data[index] as Spot).scale
	var smallest_size: float = min(image.size.x,image.size.y)
	spots[index].size = Vector2.ONE * smallest_size / 10

func correct_image_pos_size():
	var big_square: Vector2 = image.size
	var smol_square: Vector2 = image.texture.get_size()
	image.size.x = big_square.y / smol_square.y * smol_square.x
	image.position.x = image.get_parent().size.x / 2 - image.size.x / 2

func load_task(task_data: TaskData) -> void:
	super(task_data)
	var spot_task_data : SpotTaskData = task_data as SpotTaskData
	spot_data = spot_task_data.spots
	
	right_answer = spot_task_data.answer
	label.text = spot_task_data.question
	
	image.texture = spot_task_data.image
	correct_image_pos_size()
	
	for i in range(spot_data.size()):
		var instance: TextureButton = spot_button.instantiate()
		image.add_child.call_deferred(instance)
		spots.push_back(instance)
		correct_spot(i)
		connect_spot(i)

func show_answers():
	for i in range(spots.size()):
		if show_everything:
			texture_spot(i)
		spots[i].disabled = true

func right(index: int):
	spots[index].texture_disabled = spot_correct
	passed.emit(points)
	show_answers()
	finished.emit()
