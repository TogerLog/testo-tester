extends UIArray
class_name UIArrayString

var data_array: Array[String]

signal array_changed(new_data_array: Array[String])

var loading: bool = false

func clear_data_and_ui():
	data_array.clear()
	for el in elements:
		el.queue_free()
	elements.clear()

func load_data(arr: Array[String]) -> void:
	loading = true
	clear_data_and_ui()
	for string in arr:
		var index: int = create_new_ui_element()
		data_array.push_back(string)
		var element_obj: UIArrayElementString = elements[index] as UIArrayElementString
		element_obj.line_edit.text = string
	loading = false

func change_data(new_text: String,index: int) -> void:
	if loading:
		return
	data_array[index] = new_text
	array_changed.emit(data_array.duplicate(true))

func reset_signals():
	for element in range(elements.size()):
		var element_obj: UIArrayElementString = elements[element] as UIArrayElementString
		if element_obj.line_edit.focus_entered.is_connected(delete):
			element_obj.line_edit.focus_entered.disconnect(delete)
			element_obj.line_edit.text_changed.disconnect(change_data)
			element_obj.move_down.disconnect(move_down)
			element_obj.move_up.disconnect(move_up)
		
		element_obj.line_edit.text_changed.connect(change_data.bind(element))
		element_obj.line_edit.focus_entered.connect(delete.bind(element))
		element_obj.move_down.connect(move_down.bind(element))
		element_obj.move_up.connect(move_up.bind(element))

func move_down_data(index: int):
	var prev_data: String = data_array[index]
	data_array[index] = data_array[index + 1]
	data_array[index + 1] = prev_data
	array_changed.emit(data_array)

func move_up_data(index: int):
	var prev_data: String = data_array[index]
	data_array[index] = data_array[index - 1]
	data_array[index - 1] = prev_data
	array_changed.emit(data_array)

func delete_data(index: int) -> void:
	data_array.remove_at(index)
	array_changed.emit(data_array)

func new_data(_node: UIArrayElement) -> void:
	data_array.push_back("")
	reset_signals()
	array_changed.emit(data_array)
