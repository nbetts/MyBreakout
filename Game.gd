extends Node

onready var field = $Field
onready var ui = $UI

func _ready():
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		ui.set_deferred("visible", true)
		ui.openPauseMenu()
		

func _on_UI_level_selected(level):
	ui.set_deferred("visible", false)
	ui.levelSelectMenu.set_deferred("visible", false)
	field.set_deferred("visible", true)
	field.begin_game(level)
	get_tree().paused = false


func _on_UI_unpaused():
	get_tree().paused = false


func _on_UI_level_unselected():
	field.set_deferred("visible", false)
