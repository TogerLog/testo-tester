extends UIArray
class_name UIArrayPair

var data_array: Array[Pair]

signal array_changed(new_data_array: Array[Pair])

var loading: bool = false

func clear_data_and_ui():
	data_array.clear()
	for el in elements:
		el.queue_free()
	elements.clear()

func load_data(arr: Array[Pair]) -> void:
	loading = true
	clear_data_and_ui()
	for pair in arr:
		var index: int = create_new_ui_element()
		data_array.push_back(pair)
		var pair_element: UIArrayElementPair = elements[index] as UIArrayElementPair
		pair_element.first_node.text = pair.first_val
		pair_element.second_node.text = pair.second_val
	loading = false

func change_first_value(new_first_val: String,index: int) -> void:
	if loading:
		return
	data_array[index].first_val = new_first_val
	array_changed.emit(data_array)

func change_second_value(new_second_val: String,index: int) -> void:
	if loading:
		return
	data_array[index].second_val = new_second_val
	array_changed.emit(data_array)

func reset_signals():
	for element in range(elements.size()):
		var pair_element = elements[element] as UIArrayElementPair
		
		if pair_element.first_node.focus_entered.is_connected(delete):
			pair_element.first_node.focus_entered.disconnect(delete)
			pair_element.first_node.text_changed.disconnect(change_first_value)
			pair_element.second_node.focus_entered.disconnect(delete)
			pair_element.second_node.text_changed.disconnect(change_second_value)
			pair_element.move_down.disconnect(move_down)
			pair_element.move_up.disconnect(move_up)
		
		pair_element.first_node.focus_entered.connect(delete.bind(element))
		pair_element.first_node.text_changed.connect(change_first_value.bind(element))
		pair_element.second_node.focus_entered.connect(delete.bind(element))
		pair_element.second_node.text_changed.connect(change_second_value.bind(element))
		pair_element.move_down.connect(move_down.bind(element))
		pair_element.move_up.connect(move_up.bind(element))

func move_down_data(index: int):
	var prev_data: Pair = data_array[index]
	data_array[index] = data_array[index + 1]
	data_array[index + 1] = prev_data
	array_changed.emit(data_array)

func move_up_data(index: int):
	var prev_data: Pair = data_array[index]
	data_array[index] = data_array[index - 1]
	data_array[index - 1] = prev_data
	array_changed.emit(data_array)

func delete_data(index: int) -> void:
	data_array.remove_at(index)
	array_changed.emit(data_array)

func _on_new_pressed() -> int:
	if elements.size() + 1 > limit && limit != -1:
		return -1
	var node: UIArrayElementPair = element_prefab.instantiate()
	elements_parent.add_child(node)
	elements.push_back(node)
	node.first_node.focus_entered.connect(delete.bind(elements.size() - 1))
	node.second_node.focus_entered.connect(delete.bind(elements.size() - 1))
	node.move_down.connect(move_down.bind(elements.size() - 1))
	node.move_up.connect(move_up.bind(elements.size() - 1))
	new_data(node)
	return elements.size() - 1

func new_data(node: UIArrayElement) -> void:
	data_array.push_back(Pair.new())
	var pair_element = node as UIArrayElementPair
	var first_node: LineEdit = pair_element.first_node as LineEdit
	var second_node: LineEdit = pair_element.second_node as LineEdit
	first_node.text_changed.connect(change_first_value.bind(data_array.size() - 1))
	second_node.text_changed.connect(change_second_value.bind(data_array.size() - 1))
	reset_signals()
	array_changed.emit(data_array)
