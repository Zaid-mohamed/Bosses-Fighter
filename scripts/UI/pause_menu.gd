extends Control
class_name  PauseMenu

#region buttons
@onready var resume_button: Button = $MarginContainer/VBoxContainer/Resume_button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Quit_button
#endregion

@onready var pause_menu: Control = $"."




func _process(delta):
	#if clicked pause
	if Input.is_action_just_pressed("Pause"):
		# show the pause menu
		show()
		# create a tween for the time
		var time_tween = create_tween()
		# tween the time scale to be very very low
		time_tween.tween_property(Engine, "time_scale", 0.01, 0.2)
		



# when resume button is clicked
func _on_resume_button_pressed():
	# hide the resume button
	hide()
	# create a tween for the time
	var time_tween = create_tween()
	# tween the time scale to be normal
	time_tween.tween_property(Engine, "time_scale", 1.0, 0.2)


# if quit button clicked
func _on_quit_button_pressed():
	# quit
	get_tree().quit()
