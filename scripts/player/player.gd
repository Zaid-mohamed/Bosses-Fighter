extends CharacterBody2D


# a group of exported variables for motion quantaties

@export_group("movement stats")
# speed
@export var speed : float
# acceleration
@export var accel : float
# deceleration
@export var decel : float
func _physics_process(delta: float) -> void:
	movement()





# the function that handle movement
func movement():
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var intended_velocity = input_direction * speed
	
	if input_direction:
		velocity = velocity.move_toward(intended_velocity, accel * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decel * get_physics_process_delta_time())
	move_and_slide()
