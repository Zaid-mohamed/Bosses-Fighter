extends Control
class_name  PauseMenu

#region buttons
@onready var resume_button: Button = $MarginContainer/VBoxContainer/Resume_button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Quit_button
#endregion

@onready var pause_menu: Control = $"."

func _on_resume_button_pressed():
	get_tree().paused = false
	hide()


func _on_quit_button_pressed():
	get_tree().quit()
