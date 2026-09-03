extends Task
class_name ChronoTask

@export var blocks: Array[ChronoBlock]
@export var container: VBoxContainer
@export var chrono_block: PackedScene
@export var timer: Timer
@export var cover: Control
@export var label: Label

@export var right_button: Texture2D
@export var wrong_button: Texture2D

var buffer: Array[int]
var next_gen_buffer: Array[int]
var index: int
var checked: int

@export var accept_button: TextureButton

func load_task(task_data: TaskData) -> void:
	super(task_data)
	var chrono_data: ChronoTaskData = task_data as ChronoTaskData
	label.text = chrono_data.hint
	var shuffled_pairs: Array[String] = chrono_data.pairs.duplicate(true)
	shuffled_pairs.shuffle()
	for chron_pair in range(shuffled_pairs.size()):
		var block: ChronoBlock = chrono_block.instantiate()
		blocks.push_back(block)
		container.add_child(block)
		block.set_text(shuffled_pairs[chron_pair])
		block.set_needed_index(chrono_data.pairs.find(shuffled_pairs[chron_pair]))
		block.swap.connect(swap)

func check_answer():
	while buffer.has(index):
		index += 1
	
	if index < blocks.size():
		if blocks[index].is_correct() && !buffer.has(index):
			buffer.push_back(index)
			blocks[index].texture_disabled = right_button
			blocks[index].disabled = true
			passed.emit(0)
		else:
			failed.emit(0)
			blocks[index].texture_disabled = wrong_button
			blocks[index].texture_normal = wrong_button
	checked += 1
	index += 1
	if checked < blocks.size() - next_gen_buffer.size():
		timer.start()
	elif buffer.size() == blocks.size():
		passed.emit(points)
		finished.emit()
	else:
		failed.emit(penalty)
		if one_shot or buffer.size() == blocks.size():
			finished.emit()
			return
		if index + 1 < blocks.size():
			timer.start()
		else:
			timer.wait_time = 0.4
			cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
			accept_button.disabled = false
			for block in range(blocks.size()):
				if !buffer.has(block):
					blocks[block].disabled = false

func swap(index1: int, index2: int):
	var temp = blocks[index1]
	blocks[index1] = blocks[index2]
	blocks[index2] = temp

func _on_accepted() -> void:
	cover.mouse_filter = Control.MOUSE_FILTER_STOP
	index = 0
	checked = 0
	next_gen_buffer = buffer.duplicate(true)
	for block in range(blocks.size()):
		if !buffer.has(block):
			blocks[block].texture_disabled = blocks[block].white
			blocks[block].disabled = true
	accept_button.disabled = true
	
	check_answer()
