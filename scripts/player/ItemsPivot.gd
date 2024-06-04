extends Node2D



###########################################
##########################################

## this mechanic is not finished don't try to complete it!

##############################################
##############################################






# the length of the hit in pixels
@export var hit_length : float


# an indicator used to know where is the original position of the holded item
@onready var org_pos_indicator: Marker2D = %OrgPosIndicator

# a timer that prevent the player from over hitting, and also used to avoid some glitches
@onready var hit_cool_down: Timer = %HitCoolDown

# the node of the current holded item
var holded_item : Node2D: 
	get:
		return get_child(0)

# can the pivot rotate ?
var can_rotate : bool = true

# is currently hitting?
var hitting : bool = false


func _process(delta: float) -> void:
	
	handle_rotations()
	
	# if pressed attack and not already hitting
	if Input.is_action_just_pressed("attack") && !hitting:
		hit()


# the function that handles the rotation of the pivot
func handle_rotations():
	# if can not rotate return 
	if !can_rotate: return
	
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	# lerp the rotation to the mouse direction angle (you can send me to explain more)
	rotation = lerp_angle(rotation, mouse_direction.angle(), 0.4)
	
func hit():
	#if already hitting, return
	if hitting:
		return
	
	# we are hitting now
	hitting = true
	# we also can not rotate while hitting
	can_rotate = false 
	
	# start the cool down
	hit_cool_down.start()
	
	var hit_direction = (get_local_mouse_position() - position).normalized()
	
	# here I saved the position and rotation of the indicator (it has the same values of the holded item)
	
	var hold_item_current_pos = org_pos_indicator.position
	var holded_item_current_angle = org_pos_indicator.rotation
	
	# the tween that will do the hit
	var hit_tween = create_tween()
	
	# push
	hit_tween.tween_property(holded_item, "position", holded_item.position + hit_direction * hit_length, 0.1)
	# pull
	hit_tween.tween_property(holded_item, "position", hold_item_current_pos, 0.1)
	#fix rotation
	hit_tween.tween_property(holded_item, "rotation", holded_item_current_angle, 0.1)



# when the cool down ends 
func _on_hit_cool_down_timeout() -> void:
	# we are now not hitting
	hitting = false
	# and can rotate
	can_rotate = true
