extends Node

onready var field = $Field
onready var ui = $UI

func _ready():
	get_tree().paused = true


func _input(event):
	# just for testing
	if event.is_action_pressed("ui_cancel") and ui.visible == false:
		print('open menu')
		get_tree().paused = true
		ui.set_deferred("visible", true)
		field.set_deferred("visible", false)
		


func _on_UI_pressed_play():
	ui.set_deferred("visible", false)
	field.set_deferred("visible", true)
	field.begin_game()
	get_tree().paused = false


func _on_UI_pressed_quit():
	get_tree().quit()
