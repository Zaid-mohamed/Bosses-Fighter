extends Area2D
class_name OnGroundButton


# the childeren nodes:


@onready var button_sprite: Sprite2D = %ButtonSprite
@onready var title_label: Label = %TitleLabel



# the enum that contains the states of the button (i currently pressed, or released (not signals)
enum pressed_states {
	pressed,
	released
}

# the variable that contains the value of the if the Button Pressed or realeased (not signals)
var pressed_state := pressed_states.released



# when a body is entered (the player)

func _on_body_entered(body: Node2D) -> void:
	# if the body is the button it self return
	if body == get_parent():
		return
	
	
	# and if the button is not pressed
	if pressed_state == pressed_states.pressed:
		return
	
	
	# the state will be pressed
	pressed_state = pressed_states.pressed
	# button sprite will be pressed (shape)
	button_sprite.frame += 1
	
	# lower the label to match the pressed shape sprite
	title_label.global_position.y += 3.5


func _on_body_exited(body: Node2D) -> void:
	# if the body is the button itself return
	if body == get_parent():
		return
	# if the button is already released (in released state), return
	if pressed_state == pressed_states.released:
		return
	
	# make the button in released state
	pressed_state = pressed_states.released
	
	# button sprite will be released (shape)
	button_sprite.frame -= 1
	# raise the label to match the released shape sprite 
	title_label.global_position.y -= 3.5
	
