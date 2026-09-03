extends UIArrayElement
class_name ISpotConfigurer

@export var spot: ISpot
@export var index_label: Label
@export var index: int

@export var stoper: Control

signal configure()

func _ready() -> void:
	spot = ISpot.new()

func deleting():
	stoper.visible = true

func deleting_done():
	stoper.visible = false

func load_data(new_num_index: int,new_test_data: TestData, new_spot: ISpot = null, new_index: String = ""):
	if new_spot:
		spot = new_spot
	index_label.text = str(new_num_index)
 
func update():
	return

func _on_configure_pressed() -> void:
	configure.emit()
