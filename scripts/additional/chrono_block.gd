extends TextureButton
class_name ChronoBlock

@export var needed_index: int = 0
@export var label: Label
@export var collision_control: Control

@export var chosen: Control

@export var white: Texture2D
@export var normal: Texture2D

var original_pos: Vector2

var _is_pressed: bool = false

func set_needed_index(index: int):
	needed_index = index

func _ready() -> void:
	original_pos = global_position

func _process(_delta: float) -> void:
	if _is_pressed:
		global_position.y = get_global_mouse_position().y - size.y / 2
		collision()

func is_correct() -> bool:
	return get_index() == needed_index

func collision() -> void:
	var children: Array[Node] = get_parent().get_children()
	var is_chosen: bool = false
	for child in children:
		if child == self:
			continue
		var control_child: ChronoBlock = child as ChronoBlock
		control_child.normaln()
		if collision_control.get_global_rect().intersects(control_child.collision_control.get_global_rect()) && !is_chosen:
			chosen = control_child
			is_chosen = true
			control_child.whiten()
	if is_chosen == false:
		chosen = null

func set_text(new_text: String) -> void:
	label.text = new_text

func whiten() -> void:
	texture_normal = white

func normaln() -> void:
	texture_normal = normal

signal swap(index1: int, index2: int)

func swap_index(other_node: Control):
	var parent = get_parent()
	
	var my_index: int = get_index()
	var other_index: int = other_node.get_index()
	swap.emit(my_index,other_index)
	parent.move_child(self, other_index)
	parent.move_child(other_node,my_index)
	
	chosen = null

func button_down() -> void:
	modulate.a = 0.5
	texture_disabled = white
	original_pos = global_position
	z_index = 1
	_is_pressed = true
	whiten()

func button_up() -> void:
	_is_pressed = false
	modulate.a = 1
	z_index = 0
	if chosen != null:
		swap_index(chosen)
	else:
		global_position = original_pos
	var children: Array[Node] = get_parent().get_children()
	for child in children:
		var control_child: ChronoBlock = child as ChronoBlock
		control_child.normaln()
