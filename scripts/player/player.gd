extends CharacterBody2D
class_name Player

# a group of exported variables for motion quantaties
@export_group("movement stats")
# speed
@export var speed : float
# acceleration
@export var accel : float
# deceleration
@export var decel : float


# the current item the player holds
@export var current_item_data : ItemData
# onready vars

@onready var item: Item = %Item
@onready var body: Sprite2D = %body
@onready var anim: AnimationPlayer = %Anim
@onready var shadow: Sprite2D = %shadow
@onready var inventory_dialog: Inventory = %PlayerInventoryDialog
@onready var hotbar: Hotbar = %Hotbar
@onready var item_info: ItemInfo = %ItemInfo
@onready var health = %Health
# sounds
@onready var walk_sx: AudioStreamPlayer2D = %walk_sx
@onready var attack_sx: AudioStreamPlayer2D = %attack_sx




func _ready() -> void:
	item.update_data(current_item_data)


func _physics_process(delta: float) -> void:
	movement()
	handle_animation()
	handle_facing()




# the function that handle movement
func movement():
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var intended_velocity = input_direction * speed
	
	if input_direction:
		velocity = velocity.move_toward(intended_velocity, accel * get_physics_process_delta_time())
		# play the walking sound if not alreadyv plaing
		if !walk_sx.playing : walk_sx.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decel * get_physics_process_delta_time())
		# stop the walking sound
		walk_sx.stop()
	move_and_slide()

# handles the direction the player faces
func handle_facing():
	
	if Input.is_action_just_pressed("ui_left") && !body.flip_h:
		# make the sprite look left
		body.flip_h = true
		# move the shadow to match the sprite (the body)
		shadow.position.x = 0.5
	elif Input.is_action_just_pressed("ui_right") && body.flip_h:
		# make the sprite look right
		body.flip_h = false
		# move the shadow to match the sprite (the body)
		shadow.position.x = -0.5

# the function that handles the animations
func handle_animation():
	if velocity != Vector2.ZERO:
		anim.play("Run", 0.25)
	else:
		anim.play("Idle", 0.25)



# a connector connects current_slot_data changed signal from Hotbar
func _on_hotbar_current_slot_data_changed(new_current_slot_data: SlotData) -> void:
	# update the current_item_data if the new_current_slot is valid, else will be null
	current_item_data = new_current_slot_data.item_data if new_current_slot_data else null
	# if the new_current_slot_data is null, push an error
	if !new_current_slot_data:
		push_error("new_current_slot_data is null")
	# update the visualls, animation,etc
	await get_tree().physics_frame
	item.update_data(current_item_data)


func _on_health_took_damage(amount):
	if health.health == 0: return # if it died, don't do the effects
	#region adding tweens
	var time_scale_tween = create_tween()
	var camera_zoom_tween = create_tween()
	var camera_offset_tween = create_tween()
	var camera_rotation_tween = create_tween()
	var walk_sx_tween = create_tween()
	#endregions
	
	#region setting the tweens trans to cubic
	camera_zoom_tween.set_trans(Tween.TRANS_CUBIC)
	time_scale_tween.set_trans(Tween.TRANS_CUBIC)
	camera_offset_tween.set_trans(Tween.TRANS_CUBIC)
	camera_rotation_tween.set_trans(Tween.TRANS_CUBIC)
	walk_sx_tween.set_trans(Tween.TRANS_CUBIC)
	#endregion
	
	
	#region apply tweens (zahab)
	
	# decreasing time scale
	time_scale_tween.tween_property(Engine, "time_scale", 0.1, 0.2)
	# zooming in a bit
	camera_zoom_tween.tween_property($Camera, "zoom", Vector2(1.5, 1.5), 0.2)
	# making the camera in  center
	camera_offset_tween.tween_property($Camera, "offset", Vector2.ZERO, 0.2)
	# change the rotation of camera accoring player movement
	camera_rotation_tween.tween_property($Camera, "rotation", deg_to_rad(20.0 * -sign(velocity.x)), 0.2)
	# decreasing the pitch scale of the walking sound effects
	walk_sx_tween.tween_property(walk_sx, "pitch_scale", 0.2, 0.2)
	#endregion
	
	# region back to normal
	
	time_scale_tween.tween_property(Engine, "time_scale", 1.0, 0.1)
	camera_zoom_tween.tween_property($Camera, "zoom", Vector2.ONE, 0.1)
	camera_rotation_tween.tween_property($Camera, "rotation", 0.0, 0.1)
	walk_sx_tween.tween_property(walk_sx, "pitch_scale", 1, 0.2)
	#endregion
	

func _on_health_died():
	SceneChanger.change_scene("res://scenes/UI/Menus/die_screen.tscn")
