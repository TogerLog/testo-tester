extends Control
class_name UIArrayElement

signal move_up()

signal move_down()

func deleting():
	return

func deleting_done():
	return

func _on_move_up():
	move_up.emit()

func _on_move_down():
	move_down.emit()
