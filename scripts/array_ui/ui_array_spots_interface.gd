extends UIArray
class_name IUIArraySpots

var data_array: Array[ISpot]
var test_data: TestData
var id: int = 0

func reset_signals():
	for element in range(elements.size()):
		var element_obj: ISpotConfigurer = elements[element] as ISpotConfigurer
		if element_obj.stoper.focus_entered.is_connected(delete):
			element_obj.stoper.focus_entered.disconnect(delete)
			element_obj.move_down.disconnect(move_down)
			element_obj.move_up.disconnect(move_up)
			#element_obj.configure.disconnect(ui_data.configure_spot.bind(element))
		element_obj.stoper.focus_entered.connect(delete.bind(element))
		element_obj.move_down.connect(move_down.bind(element))
		element_obj.move_up.connect(move_up.bind(element))
		#element_obj.configure.connect(ui_data.configure_spot.bind(element))

func clear_data_and_ui():
	id = 0
	data_array.clear()
	for el in elements:
		el.queue_free()
	elements.clear()

func delete_data(_index: int) -> void:
	data_array.remove_at(_index)

func new_data(_node: UIArrayElement) -> void:
	id += 1
	data_array.push_back(ISpot.new())
	var node: ISpotConfigurer = _node as ISpotConfigurer
	node.load_data(id,test_data,data_array[-1])

func load_data(new_arr: Array[ISpot],new_test_data: TestData):
	clear_data_and_ui()
	data_array = new_arr
	test_data = new_test_data
	for data in data_array:
		elements.push_back(element_prefab.instantiate())
		elements_parent.add_child(elements[-1])
		var el: ISpotConfigurer = elements[-1] as ISpotConfigurer
		el.load_data(data_array.size() - 1,test_data,data,data.image_id)
