extends Camera2D
class_name PlayerCamera

# the character body 2d node that holds the player
@export var player_node : CharacterBody2D


@export_group("Offsets")

## the offset length that the camera when camera offset towards the mouse position
@export var mouse_offset : float = 10.0

## same as above but offset according to player velocity
@export var velocity_offset : float = 10.0


func _process(delta: float) -> void:
	# if the player is not moving
	if player_node.velocity == Vector2.ZERO:
		change_offset_according_to_mouse_position() 
	else: # if it is moving
		change_offset_according_to_player_velocity()



func change_offset_according_to_player_velocity():
	offset = offset.lerp(player_node.velocity.normalized() * velocity_offset, 0.07)
func change_offset_according_to_mouse_position():
	offset = offset.lerp((get_global_mouse_position() - player_node.global_position).normalized() * mouse_offset, 0.07)
