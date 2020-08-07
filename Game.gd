extends Node

onready var field_scene = preload("res://entities/field/Field.tscn")
onready var ui = $CanvasLayer/UI

var field = null
var current_level = null

func _ready():
	randomize()
	pause()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ui.openPauseMenu()


func quit():
	get_tree().quit()


func pause():
	get_tree().paused = true


func unpause():
	get_tree().paused = false


func hide_all_menus():
	for menu in ui.get_children():
		menu.hide()

	unpause()


func open_menu(menu_name):
	for menu in ui.get_children():
		if (menu.get_name() == menu_name):
			menu.show()
			pause()
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
	ui.open_game_over_menu('You Won!')


func game_over():
	ui.open_game_over_menu('Game Over!')


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
