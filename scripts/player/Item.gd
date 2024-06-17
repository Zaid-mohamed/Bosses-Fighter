class_name Item extends Node2D

# the sprite of the item
@export var sprite : Sprite2D

# the animation player that plays the item animations
@export var item_anim : AnimationPlayer

# the hitbox of the item if it is melee
@onready var item_hit_box: HitBox = %ItemHitBox

# the timer that when timeout the character is bored and plays the bored animation
@onready var bored_timer: Timer = %BoredTimer

# the attack sound player
@onready var attack_sx: AudioStreamPlayer2D = %attack_sx

# can the pivot rotate ?
var can_rotate : bool = true


const ARROW_SCENE = preload("res://scenes/weapons/arrow.tscn")

func _ready() -> void:
	# connect the timeout signal to play animation bored 
	
	bored_timer.timeout.connect(func(): play_animation("Bored", get_owner().current_item_data))



func _process(delta: float) -> void:
	# handle input
	handle_input()
	# handle_rotation (make the item look to the mouse)
	handle_rotations()
	

func update_data(data : ItemData):
	sprite.texture = data.texture if data else null
	item_hit_box.damage_amount = data.damage_amount if data else 0
	item_hit_box.knock_back_force = data.knock_back_force if data else 0.0
	update_animation(data)
	if !data:
		sprite.texture = null
		update_animation(data)



# update the animation library of anim player according to an item data
func update_animation(data : ItemData):
	play_animation("RESET", data)
	item_anim.stop()
	
	
	for library in item_anim.get_animation_library_list():
		item_anim.remove_animation_library(library)
	if !data:
		return
	else:
		
		item_anim.add_animation_library(data.anim_library.resource_name, data.anim_library)
	
	


# the function that plays the animation (instead of anim.play function)
func play_animation(anim_name : String, data : ItemData):
	if data:
		
		item_anim.play("%s/%s" % [data.anim_library.resource_name, anim_name])
	
	
# the function that handles the rotation of the pivot
func handle_rotations():
	# if can not rotate return 
	if !can_rotate: return
	
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	# lerp the rotation to the mouse direction angle (you can send me to explain more)
	rotation = lerp_angle(rotation, mouse_direction.angle(), 0.4)
	
	
func handle_input():
	if Input.is_action_just_pressed("use") && get_owner().current_item_data:
		# play attack sound
		attack_sx.play()
		# if pressed attack play use animation
		play_animation("Use", get_owner().current_item_data)
		# and restart the bored timer
		restart_bored_timer()
	

# restart the bored timer to prevent playing bored animation with attack animation
func restart_bored_timer():
	bored_timer.stop()
	bored_timer.start()




func bow_shoot():
	var shoot_direction = (get_global_mouse_position() - global_position).normalized()
	var arrow = ARROW_SCENE.instantiate()
	var shoot_velocity = shoot_direction * arrow.speed
	arrow.global_position = sprite.global_position
	get_tree().root.add_child(arrow)
	arrow.velocity = shoot_velocity
