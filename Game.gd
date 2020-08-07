extends Node

onready var field_scene = preload("res://entities/field/Field.tscn")
onready var ui = $CanvasLayer/UI

var field = null
var current_level = null

func _ready():
	randomize()
	pause()
	open_menu("MainMenu")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ui.openPauseMenu()


func quit():
	get_tree().quit()


func pause():
	get_tree().set_deferred("paused", true)


func unpause():
	get_tree().set_deferred("paused", false)


func hide_all_menus():
	for menu in ui.get_children():
		menu.hide()

	unpause()


func open_menu(menu_name):
	for menu in ui.get_children():
		if (menu.get_name() == menu_name):
			menu.show()
			pause()
			
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
	# todo: update level button colours to green if they have been completed
	#for level_button in levelSelectMenu.get_child(0).get_children():
	#	level_button.set("custom_colors/font_color", "#5ce614")


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


func game_over():
	open_menu("LevelLostMenu")


func unmount_level():
	current_level = null

	if field != null:
		field.queue_free()


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
