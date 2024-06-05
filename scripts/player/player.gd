extends CharacterBody2D


# a group of exported variables for motion quantaties

@export_group("movement stats")
# speed
@export var speed : float
# acceleration
@export var accel : float
# deceleration
@export var decel : float

@export var item_data : ItemData
# onready vars

@onready var item: Item = %Item

@onready var body: Sprite2D = %body
@onready var anim: AnimationPlayer = %Anim



func _ready() -> void:
	item.update_data(item_data)


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
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decel * get_physics_process_delta_time())
	move_and_slide()

# handles the direction the player faces
func handle_facing():
	if Input.is_action_just_pressed("ui_left"):
		body.flip_h = true
	elif Input.is_action_just_pressed("ui_right"):
		body.flip_h = false

# the function that handles the animations
func handle_animation():
	if velocity != Vector2.ZERO:
		anim.play("Run", 0.25)
	else:
		anim.play("Idle", 0.25)


