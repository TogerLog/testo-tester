extends Task
class_name TaskNone

@export var button: TextureButton

func SKIP():
	button.disabled = true
	passed.emit()
	finished.emit()
