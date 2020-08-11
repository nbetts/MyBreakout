extends Node

onready var field_scene = preload("res://entities/field/Field.tscn")
onready var ui = $CanvasLayer/UI
onready var blur_shader = $CanvasLayer/BlurShader

const save_file_name = "user://user_data.save"
var default_user_data = {
	"levels_completed": []
}
var user_data = {}

var field = null
var current_level = null

func _ready():
	randomize()
	pause()
	open_menu("MainMenu")
	load_user_data()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ui.openPauseMenu()


func load_user_data():
	var save_file = File.new()
	if save_file.file_exists(save_file_name):
		save_file.open(save_file_name, File.READ)
		user_data = parse_json(save_file.get_line())
		save_file.close()
	else:
		reset_user_data()


func save_user_data():
	var save_file = File.new()
	save_file.open(save_file_name, File.WRITE)
	save_file.store_line(to_json(user_data))
	save_file.close()


func reset_user_data():
	user_data = default_user_data.duplicate()
	save_user_data()


func quit():
	get_tree().quit()


func pause():
	get_tree().set_deferred("paused", true)


func unpause():
	get_tree().set_deferred("paused", false)


func hide_all_menus():
	for menu in ui.get_children():
		if menu.is_in_group("Menus"):
			menu.hide()

	blur_shader.hide()
	unpause()


func open_menu(menu_name):
	for menu in ui.get_children():
		if menu.is_in_group("Menus"):
			if (menu.get_name() == menu_name):
				menu.show()
				pause()
				if field != null and field.is_playing:
					blur_shader.show()
				
				# Focus on first button
				var child = menu
				var child_count = menu.get_child_count()
				while child_count > 0 and not (child is Button or child is MyButton):
					child = child.get_child(0)
					child_count = child.get_child_count()
				
				if (child is Button or child is MyButton):
					child.grab_focus()
			else:
				menu.hide()


func open_level_select_menu():
	unmount_level()
	open_menu("LevelSelectMenu")
	
	# enable/disable level buttons based on which levels have been completed
	var automaticallyEnableLevelButton = true

	for level_button in ui.get_node("LevelSelectMenu/Levels").get_children():
		if int(level_button.text) in user_data["levels_completed"]:
			level_button.set("disabled", false)
			automaticallyEnableLevelButton = true
		elif automaticallyEnableLevelButton:
			level_button.set("disabled", false)
			automaticallyEnableLevelButton = false
		else:
			level_button.set("disabled", true)


func play_level(level):
	unmount_level()
	current_level = level

	# add field scene
	field = field_scene.instance()
	field.connect("game_won", self, "game_won");
	field.connect("game_over", self, "game_over");
	add_child(field)
	hide_all_menus()
	field.begin_game(level)


func restart_level():
	play_level(current_level)


func game_won():
	open_menu("LevelWonMenu")
	if not current_level in user_data["levels_completed"]:
		var levels_completed = user_data["levels_completed"]
		levels_completed.append(current_level)
		user_data["levels_completed"] = levels_completed
		save_user_data()


func game_over():
	open_menu("LevelLostMenu")


func unmount_level():
	current_level = null
	if field != null:
		field.end_game()
		field.queue_free()
		blur_shader.hide()


func _on_UI_quitted():
	quit()


func _on_UI_all_menus_hidden():
	hide_all_menus()


func _on_UI_menu_opened(menu_name):
	open_menu(menu_name)


func _on_UI_level_select_menu_opened():
	open_level_select_menu()


func _on_UI_level_selected(level):
	play_level(level)


func _on_UI_level_restarted():
	restart_level()
