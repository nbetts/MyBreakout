class_name MyButton
extends Button

onready var clickSound = $ClickSound

func _on_Button_focus_entered():
	clickSound.play()


func _on_MyButton_button_down():
	clickSound.play()
