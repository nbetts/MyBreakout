class_name Menu
extends VBoxContainer

export var default_focus_button_path: NodePath

func set_default_button_focus():
	if not default_focus_button_path.is_empty():
		var button: MyButton = get_node(default_focus_button_path)
		button.grab_focus()
