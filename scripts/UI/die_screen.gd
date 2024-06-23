extends Control

@onready var you_died_text = %YouDiedText


@export var messages = ["You Died Noob!", "Died Again?", "You Can't Do it!!", "Die & Die & Die"]

func _ready():
	you_died_text.text = "[wave]" + choose_message()



func choose_message():
	var rng = RandomNumberGenerator.new()
	
	var picker = rng.randi_range(0, messages.size() -1)
	
	return messages[picker]


func _on_replay_button_pressed():
	SceneChanger.change_scene("res://scenes/UI/Menus/main_menu.tscn")
