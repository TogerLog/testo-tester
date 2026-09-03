extends Task
class_name LinkTask

@export var left_blocks: Array[LeftBlock]
@export var right_blocks: Array[RightBlock]

@export var left_block: PackedScene
@export var right_block: PackedScene

@export var left_father: Node
@export var right_father: Node

@export var chosen_blocks: Array[LeftBlock]
var buffer: Array[int]
@export var how_many_answered: int = 0

@export var index: int = 0
@export var how_many_right: int = 0
@export var how_many_visible: int = 0

@export var check_timer: Timer

@export var checking: bool = false
@export var accept_button: SimpleButton
@export var label: Label

func _ready() -> void:
	how_many_visible = chosen_blocks.size()

func check_answer():
	while buffer.has(index):
		index += 1
	if index < chosen_blocks.size():
		if chosen_blocks[index].check_answer():
			passed.emit(0)
			buffer.push_back(index)
			how_many_right += 1
		else:
			failed.emit(0)
	index += 1
	if how_many_right >= how_many_visible:
		finish()
	elif index >= how_many_visible and one_shot:
		finish()
	elif index < how_many_visible:
		check_timer.start()
	else:
		failed.emit(penalty)
		check_timer.wait_time = 0.4
		accept_button.disabled = false

func add_blocks()-> void:
	var left_node: LeftBlock = left_block.instantiate() 
	left_father.add_child.call_deferred(left_node)
	left_blocks.push_back(left_node)
	var right_node = right_block.instantiate()
	right_father.add_child.call_deferred(right_node)
	right_blocks.push_back(right_node)
	
	left_node.blocks = right_blocks

func load_task(task_data: TaskData) -> void:
	super(task_data)
	
	var task = task_data.duplicate(true) as LinkTaskData
	
	label.text = task.hint
	
	how_many_visible = task.pairs.size()
	
	print_debug(how_many_visible)
	
	var unused_vals_L = range(how_many_visible)
	var unused_vals_R = range(how_many_visible)
	
	for i in range(how_many_visible):
		add_blocks()
	
	for i in range(how_many_visible):
		
		var rand = randi_range(0, unused_vals_L.size() - 1)
		var left = unused_vals_L[rand]
		unused_vals_L.remove_at(rand)
		
		rand = randi_range(0, unused_vals_R.size() - 1)
		#var right = unused_vals_R[rand]
		unused_vals_R.remove_at(rand)
		
		left_blocks[left].visible = true
		left_blocks[left].set_text(task.pairs[i].first_val)
		left_blocks[left].set_correct_answer(task.pairs[i].second_val)
		#left_blocks[left].self_modulate = Color.from_hsv(randf_range(0,1),randf_range(0.6,0.8),1)
		right_blocks[i].visible = true
		right_blocks[i].set_text(task.pairs[i].second_val)
		#right_blocks[i].self_modulate = Color.from_hsv(randf_range(0,1),randf_range(0.6,0.8),1)
		chosen_blocks.push_back(left_blocks[i])

func finish():
	if how_many_right >= how_many_visible:
		passed.emit(points,true)
	else:
		failed.emit(penalty)
	finished.emit()

func on_answer_accepted() -> void:
	index = 0
	checking = true
	accept_button.disabled = true
	check_answer()

func on_timer() -> void:
	check_answer()
