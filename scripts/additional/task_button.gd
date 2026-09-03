extends HBoxContainer
class_name TaskButton

@export var button: Button
@export var check_box: TextureButton

signal press(toggled_on: bool, node: TaskButton)

signal choose(node: TaskButton)

func _on_check_box_toggled(toggled_on: bool) -> void:
	press.emit(toggled_on,self)

func _on_button_pressed() -> void:
	choose.emit(self)
