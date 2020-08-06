extends Control

signal quitted
signal all_menus_hidden
signal menu_opened(menu_name)
signal level_select_menu_opened
signal level_selected(level)
signal level_restarted

onready var gameOverMenuLabel = $GameOverMenu/GameOverLabel

# Main menu
func _on_Play_pressed():
	emit_signal("level_select_menu_opened")


func _on_Options_pressed():
	emit_signal("menu_opened", "OptionsMenu")


func _on_Quit_pressed():
	emit_signal("quitted")


# Level select menu
func _on_LevelSelectBack_pressed():
	emit_signal("menu_opened", "MainMenu")


func _on_Levels_level_button_pressed(level):
	emit_signal("level_selected", level)


# Options menu
func _on_OptionsBack_pressed():
	emit_signal("menu_opened", "MainMenu")


# Pause menu
func openPauseMenu():
	emit_signal("menu_opened", "PauseMenu")


func _on_Continue_pressed():
	emit_signal("all_menus_hidden")


func _on_QuitLevel_pressed():
	emit_signal("level_select_menu_opened")


# Game over screen
func _on_GameOverRestartLevel_pressed():
	emit_signal("level_restarted")
	

func _on_GameOverLevelSelect_pressed():
	emit_signal("level_select_menu_opened")


# Game over screen
func open_game_over_menu(label):
	gameOverMenuLabel.text = label
	emit_signal("menu_opened", "GameOverMenu")


func _on_GameWonRestartLevel_pressed():
	emit_signal("level_restarted")
	

func _on_GameWonLevelSelect_pressed():
	emit_signal("level_select_menu_opened")
