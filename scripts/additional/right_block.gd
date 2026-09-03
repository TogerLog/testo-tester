extends TextureRect
class_name RightBlock

@export var label: Label
@export var text: String

func _ready() -> void:
	label.text = text

func set_text(new_text: String) -> void:
	label.text = new_text
	text = new_text

func get_text() -> String:
	return text
