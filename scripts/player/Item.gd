class_name Item extends Node2D

# the sprite of the item
@export var sprite : Sprite2D

# the animation player that plays the item animations
@export var anim : AnimationPlayer

@onready var bored_timer: Timer = %BoredTimer

# can the pivot rotate ?
var can_rotate : bool = true


func _ready() -> void:
	# connect the timeout signal to play animation bored 
	bored_timer.timeout.connect(func(): play_animation("Bored", get_owner().item_data))



func _process(delta: float) -> void:
	# handle input
	handle_input()
	# handle_rotation (make the item look to the mouse)
	handle_rotations()
	

func update_data(data : ItemData):
	sprite.texture = data.texture if data else null
	update_animation(data)



# update the animation library of anim player according to an item data
func update_animation(data : ItemData):
	anim.play("RESET")
	anim.stop()
	
	
	for library in anim.get_animation_library_list():
		anim.remove_animation_library(library)
	
	anim.add_animation_library(data.anim_library.resource_name, data.anim_library)
	
	


# the function that plays the animation (instead of anim.play function)
func play_animation(anim_name : String, data : ItemData):
	
	anim.play("%s/%s" % [data.anim_library.resource_name, anim_name])
	
	
# the function that handles the rotation of the pivot
func handle_rotations():
	# if can not rotate return 
	if !can_rotate: return
	
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	# lerp the rotation to the mouse direction angle (you can send me to explain more)
	rotation = lerp_angle(rotation, mouse_direction.angle(), 0.4)
	
	
func handle_input():
	if Input.is_action_just_pressed("attack"):
		# if pressed attack play attack animation
		play_animation("Attack", get_owner().item_data)
		# and restart the bored timer
		restart_bored_timer()
	


# restart the bored timer to prevent playing bored animation with attack animation
func restart_bored_timer():
	bored_timer.stop()
	bored_timer.start()
