extends Panel
class_name UIArray

@export var element_prefab: PackedScene

@export var elements_parent: Node

var elements: Array[UIArrayElement]

@export var delete_button: Button
var deleting: bool = false

@export var limit: int = -1

func delete_data(_index: int) -> void:
	return

func new_data(_node: UIArrayElement) -> void:
	return

func reset_signals():
	for element in range(elements.size()):
		var element_obj: UIArrayElement = elements[element]
		if element_obj.focus_entered.is_connected(delete): # Если добавляете новые сигналы, то подключайте/отключайте связи только здесь
			element_obj.focus_entered.disconnect(delete)
			element_obj.move_down.disconnect(move_down)
			element_obj.move_up.disconnect(move_up)
		element_obj.focus_entered.connect(delete.bind(element))
		element_obj.move_down.connect(move_down.bind(element))
		element_obj.move_up.connect(move_up.bind(element))

func delete(index: int) -> void:
	if deleting:
		elements[index].queue_free()
		elements.remove_at(index)
		delete_data(index)
		reset_signals()
		_on_delete_pressed()
	for el in elements:
		el.deleting_done()

func create_new_ui_element() -> int:
	var node: UIArrayElement = element_prefab.instantiate()
	elements_parent.add_child(node)
	elements.push_back(node)
	var node_index: int = elements.size() - 1
	reset_signals()
	return node_index

func _on_new_pressed() -> int:
	if elements.size() + 1 > limit && limit != -1:
		return -1
	var node_index: int = create_new_ui_element()
	new_data(elements[node_index])
	return node_index

func move_down_data(_index: int):
	return

func move_up_data(_index: int):
	return

func move_down(index: int):
	if index == elements.size() - 1:
		return
	elements_parent.move_child(elements[index],index + 1)
	var prev_me: Control = elements[index]
	elements[index] = elements[index + 1]
	elements[index + 1] = prev_me
	move_down_data(index)
	reset_signals()

func move_up(index: int):
	if index == 0:
		return
	elements_parent.move_child(elements[index],index - 1)
	var prev_me: Control = elements[index]
	elements[index] = elements[index - 1]
	elements[index - 1] = prev_me
	move_up_data(index)
	reset_signals()

func _on_delete_pressed() -> void:
	deleting = !deleting
	
	for el in elements:
		el.deleting()
	
	if deleting:
		delete_button.text = "ВЫБЕРИ ЗАДАНИЕ"
		delete_button.modulate = Color.RED
	else:
		delete_button.modulate = Color.WHITE
		delete_button.text = "Удалить элемент"
