extends Node2D



# the shape that will pass through the camera, and will hide
# every thing and then go away showing the new scene
@onready var transition_shape: ColorRect = %TransitionShape
# the animation player
@onready var anim = %Anim


func _ready() -> void:
	# make the shape on the left to avoid a glitch i have faced
	transition_shape.position.x = -transition_shape.size.x
 
# changes the scene with transition
func change_scene(new_scene_path):
	# start the close tween and wait until it finished
	await close().finished
	# then change the scene
	get_tree().change_scene_to_file(new_scene_path)
	# move the transition_shape_away
	open()



# the close tween, it will move the trasition_shape to hide the screen
func close() -> Tween:
	
	var close_tween = create_tween()
	
	# move the transition_shape to hide the screen
	close_tween.tween_property(transition_shape, "position:x", 0.0, 0.5)
	# reset the position of the transition shape
	anim.play("RESET")
	# it returns the tween
	return close_tween


# the open tween, it will move the trasition_shape to show the screen
func open() -> Tween:
	var open_tween = create_tween()
	# move the tranisiton shape away from the screen (to the right)
	open_tween.tween_property(transition_shape, "position:x", transition_shape.size.x, 0.5)
	# it returns the tween
	return open_tween
