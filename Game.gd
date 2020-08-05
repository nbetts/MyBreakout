extends Node

onready var field_scene = preload("res://entities/field/Field.tscn")
onready var ui = $CanvasLayer/UI

var field = null

func _ready():
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		ui.openPauseMenu()
		

func _on_UI_unpaused():
	get_tree().paused = false


func _on_UI_level_selected(level):
	ui.levelSelectMenu.set_deferred("visible", false)
	
	# add field scene
	if field != null:
		unmount_field()

	field = field_scene.instance()
	field.connect("game_won", self, "game_won");
	field.connect("game_over", self, "game_over");
	add_child(field)
	field.begin_game(level)
	get_tree().paused = false


func _on_UI_level_unselected():
	unmount_field()


func game_won():
	ui.openGameOverMenu('You Won!')
	get_tree().paused = true


func game_over():
	ui.openGameOverMenu('Game Over!')
	get_tree().paused = true


func unmount_field():
	field.queue_free()
