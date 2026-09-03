extends RightBlock

class_name LeftBlock

@export var is_button_down: bool = false
@export var pressed_texture: Texture2D
@export var normal_texture: Texture2D
@export var right_texture: Texture2D
@export var wrong_texture: Texture2D

@export var line_texture: Texture2D
@export var line_green_texture: Texture2D
@export var line_red_texture: Texture2D
@export var line_white_texture: Texture2D

@export var block_texture: Texture2D
@export var block_white_texture: Texture2D
@export var current_block: RightBlock

@export var point_start: TextureRect
@export var point_end: TextureButton
@export var line: TextureRect
@export var blocks: Array[RightBlock]
@export var chosen: String
@export var correct_answer: String
@export var one_shot: bool

var attach_position: Vector2

func set_correct_answer(answer: String) -> void:
	correct_answer = answer

func _ready() -> void:
	label.text = text

func update_line() -> void:
	var direction = (point_end.global_position - point_start.global_position)
	line.rotation = direction.normalized().angle()
	line.size.x = direction.length()

func _process(_delta: float) -> void:
	if is_button_down:
		point_end.global_position = get_viewport().get_mouse_position() - point_end.size / 2
		check_collision()
	update_line()

func check_collision() -> void:
	var is_chosen: bool = false
	for block in blocks:
		block.texture = block_texture
		if block.get_global_rect().intersects(point_end.get_global_rect()) && !is_chosen:
			block.texture = block_white_texture
			current_block = block
			is_chosen = true
	if !is_chosen:
		current_block = null

func _on_button_down() -> void:
	line.z_index = -1
	point_end.z_index = 3
	point_start.z_index = 3
	current_block = null
	is_button_down = true
	point_start.texture = pressed_texture
	point_end.texture_normal = pressed_texture
	line.texture = line_white_texture

func attach() -> bool:
	if !current_block:
		attach_position = point_start.global_position
		return false
	var nod = current_block.get_child(0) as Control
	current_block.texture = block_texture
	attach_position = nod.global_position - point_end.size / 2
	point_end.global_position = attach_position
	chosen = current_block.get_text()
	return true

func check_answer() -> bool:
	var is_right: bool = chosen == correct_answer
	
	if is_right:
		point_end.disabled = true
		point_start.texture = right_texture
		line.texture = line_green_texture
	else:
		if one_shot:
			point_end.texture_disabled = wrong_texture
			point_end.disabled = true
		else:
			point_end.texture_normal = wrong_texture
		point_start.texture = wrong_texture
		line.texture = line_red_texture
	
	return is_right

func _on_button_up() -> void:
	
	if !attach():
		point_end.global_position = point_start.global_position
		chosen = ""
	
	line.z_index = -1
	point_end.z_index = 1
	point_start.z_index = 0
	
	point_start.texture = normal_texture
	point_end.texture_normal = normal_texture
	line.texture = line_texture
	is_button_down = false
