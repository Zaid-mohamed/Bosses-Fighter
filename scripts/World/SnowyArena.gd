extends Node2D

@onready var pause_menu: PauseMenu = $Pause_Menu/Pause_menu

func _process(delta):
	if Input.is_action_pressed("Pause"):
		get_tree().paused = true
		pause_menu.show()
