extends Control

signal unpaused
signal level_selected(level)
signal level_unselected

onready var mainMenu = $MainMenu
onready var levelSelectMenu = $LevelSelectMenu
onready var optionsMenu = $OptionsMenu
onready var pauseMenu = $PauseMenu
onready var gameOverMenu = $GameOverMenu
onready var gameOverMenuLabel = $GameOverMenu/GameOverLabel

var current_level = 1

# Main menu
func _on_Play_pressed():
	mainMenu.set_deferred("visible", false)
	levelSelectMenu.set_deferred("visible", true)


func _on_Options_pressed():
	mainMenu.set_deferred("visible", false)
	optionsMenu.set_deferred("visible", true)


func _on_Quit_pressed():
	get_tree().quit()


# Level select menu
func _on_LevelSelectBack_pressed():
	mainMenu.set_deferred("visible", true)
	levelSelectMenu.set_deferred("visible", false)


# Options menu
func _on_OptionsBack_pressed():
	mainMenu.set_deferred("visible", true)
	optionsMenu.set_deferred("visible", false)


# Levels
func _on_Levels_level_button_pressed(level):
	current_level = level
	emit_signal("level_selected", current_level)


# Pause menu
func openPauseMenu():
	pauseMenu.set_deferred("visible", true)


func _on_Continue_pressed():
	pauseMenu.set_deferred("visible", false)
	emit_signal("unpaused")


func _on_QuitLevel_pressed():
	levelSelectMenu.set_deferred("visible", true)
	pauseMenu.set_deferred("visible", false)
	emit_signal("level_unselected")


# Game over screen
func _on_GameOverRestartLevel_pressed():
	gameOverMenu.set_deferred("visible", false)
	emit_signal("level_selected", current_level)
	

func _on_GameOverLevelSelect_pressed():
	gameOverMenu.set_deferred("visible", false)
	levelSelectMenu.set_deferred("visible", true)
	emit_signal("level_unselected")


# Game over screen
func openGameOverMenu(label):
	gameOverMenuLabel.text = label
	gameOverMenu.set_deferred("visible", true)


func _on_GameWonRestartLevel_pressed():
	gameOverMenu.set_deferred("visible", false)
	emit_signal("level_selected", current_level)
	

func _on_GameWonLevelSelect_pressed():
	gameOverMenu.set_deferred("visible", false)
	levelSelectMenu.set_deferred("visible", true)
	emit_signal("level_unselected")
