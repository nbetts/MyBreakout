extends Control

signal quitted
signal all_menus_hidden
signal menu_opened(menu_name)
signal level_select_menu_opened
signal level_selected(level)
signal level_restarted
signal user_data_cleared

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
func _on_OptionsClearUserData_pressed():
	emit_signal("user_data_cleared")


func _on_OptionsBack_pressed():
	emit_signal("menu_opened", "MainMenu")


# Pause menu
func openPauseMenu():
	emit_signal("menu_opened", "PauseMenu")


func _on_Continue_pressed():
	emit_signal("all_menus_hidden")


func _on_QuitLevel_pressed():
	emit_signal("level_select_menu_opened")


# Level over screen
func _on_LevelWonRestartLevel_pressed():
	emit_signal("level_restarted")


func _on_LevelWonLevelSelect_pressed():
	emit_signal("level_select_menu_opened")


func _on_LevelLostRestartLevel_pressed():
	emit_signal("level_restarted")


func _on_LevelLostLevelSelect_pressed():
	emit_signal("level_select_menu_opened")


func _on_UserDataClearedButton_pressed():
	emit_signal("menu_opened", "MainMenu")
