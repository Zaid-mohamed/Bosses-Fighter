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
	anim.play("Close")
	await anim.animation_finished
	# then change the scene
	get_tree().change_scene_to_file(new_scene_path)
	# move the transition_shape_away
	anim.play("Open")


