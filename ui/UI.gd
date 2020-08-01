extends CenterContainer

signal pressed_play
signal pressed_quit

func _on_PlayButton_pressed():
	emit_signal("pressed_play")


func _on_QuitButton_pressed():
	emit_signal("pressed_quit")
