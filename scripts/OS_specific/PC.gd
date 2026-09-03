extends RefCounted
class_name PCScript

static func create_dialog() -> Node:
	return NativeConfirmationDialog.new()
