extends CharacterBody2D


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
	# update the visualls, animation,etc
	await get_tree().physics_frame
	item.update_data(current_item_data)
