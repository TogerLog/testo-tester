extends TextureButton
class_name SimpleButton

@export var label: Label
@export var text: String
@export var wrong_texture: Texture2D 
@export var right_texture: Texture2D 

signal answer(answer: String, current_button: Node)

func _ready() -> void:
	set_text(text)

func on_pressed():
	answer.emit(text,self)

func set_text(new_text: String) -> void:
	label.text = new_text
	text = new_text

func disable(is_right: bool) -> void:
	texture_disabled = right_texture if is_right else wrong_texture
	disabled = true
