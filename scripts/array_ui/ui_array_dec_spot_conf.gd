extends IUIArraySpots
class_name UIArrayDecSpotConf

var pair_array: Array[Pair]
@export var ui_data: ImageTaskDataConfiguredUI

func update_data():
	for el in range(elements.size()):
		var img: UIElementDecSpotConf = elements[el] as UIElementDecSpotConf
		img.update.call_deferred()

func clear_data_and_ui():
	super()
	pair_array.clear()

func delete_data(_index: int) -> void:
	pair_array.remove_at(_index)

func load_data_pair(new_pair_array: Array[Pair]):
	pair_array = new_pair_array
	for el in range(elements.size()):
		var img: UIElementDecSpotConf = elements[el] as UIElementDecSpotConf
		img.load_data_pair(pair_array[el])

func new_data(_node: UIArrayElement) -> void:
	id += 1
	data_array.push_back(DecorativeSpot.new())
	pair_array.push_back(Pair.new())
	var node: UIElementDecSpotConf = _node as UIElementDecSpotConf
	node.load_data(id,test_data,data_array[-1])
	node.pair = pair_array[-1]

func get_arrays() -> Dictionary:
	var dict: Dictionary = {}
	dict["question"] = []
	dict["answer"] = []
	
	for pair in pair_array:
		dict["question"].push_back(pair.first_val)
		dict["answer"].push_back(pair.first_val)
	
	return dict

func load_data(new_arr: Array[ISpot],new_test_data: TestData):
	clear_data_and_ui()
	data_array = new_arr
	test_data = new_test_data
	for data: DecorativeSpot in data_array:
		id += 1
		elements.push_back(element_prefab.instantiate())
		elements_parent.add_child(elements[-1])
		var el: UIElementDecSpotConf = elements[-1] as UIElementDecSpotConf
		el.load_data(id,test_data,data,data.image_id)
	reset_signals()

func reset_signals():
	for element in range(elements.size()):
		var element_obj: UIElementDecSpotConf = elements[element] as UIElementDecSpotConf
		if element_obj.stoper.focus_entered.is_connected(delete):
			element_obj.stoper.focus_entered.disconnect(delete)
			element_obj.move_down.disconnect(move_down)
			element_obj.move_up.disconnect(move_up)
			element_obj.configure.disconnect(ui_data.configure_spot.bind(element))
		element_obj.stoper.focus_entered.connect(delete.bind(element))
		element_obj.move_down.connect(move_down.bind(element))
		element_obj.move_up.connect(move_up.bind(element))
		element_obj.configure.connect(ui_data.configure_spot.bind(element))
