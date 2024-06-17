extends CharacterBody2D



@onready var player := get_tree().get_first_node_in_group("player")
# the node that handles the navigation
@onready var nav_agent: NavigationAgent2D = %NavAgent
# the timer that updates the navigation
@onready var nav_timer: Timer = %NavTimer
# the timer that chooses a new wanted location
@onready var choose_location_timer: Timer = %ChooseLocationTimer
# the animation player
@onready var anim: AnimationPlayer = %Anim
# the texture of the wolf
@onready var texture: Sprite2D = %Texture

# the min and max node positions of the wante locations
# thier positions only is used
@export var min: Marker2D
@export var max: Marker2D
#////////////////////////#


# the speed of the minion
@export var speed: float
# the raduis of the locations chosen around the player
@export var locations_radius: float

# the location the minion going to currently
var wanted_location : Vector2


# is the minion can navigate?
var can_navigate : bool = true
# the states according to its distance from player.
enum states {
	AroundPlayer,
	AttackingPlayer
}


# the current state of the minion
var current_state : states = states.AroundPlayer


func _ready() -> void:
	#apply randomizing
	randomize()
	# choose the initail wanted location
	wanted_location = get_next_chosen_location()
	# set the target position to this initial wanted location
	nav_agent.set_deferred("target_position", wanted_location)


func _physics_process(delta: float) -> void:
	# handles the navigation
	navigation()
	# handles the animations
	handle_animation_and_facing()


# choose a location around the player with a given raduis
func get_next_chosen_location() -> Vector2:
	# the random generator
	var rng = RandomNumberGenerator.new()
	# the randomized chosen location
	var chosen_location = player.global_position + Vector2(rng.randf_range(-locations_radius, locations_radius),
	rng.randf_range(-locations_radius, locations_radius))
	# if the chosen location outside the borders
	if chosen_location > max.global_position || chosen_location < min.global_position:
		# run the function again and return the result
		return get_next_chosen_location() 
	else:
		# return this randomized chosen location
		return chosen_location
		
		#give the choose new location timer new randomized wait time
		choose_location_timer.wait_time = randf_range(3, 10)
	
	

func navigation() -> void:
	# if can not navigate, don't continue the "navigation" funciton
	if !can_navigate: return
	# the minion reached the wanted position, stop
	if nav_agent.is_navigation_finished():
		# start the choose location timer
		# (like the minion take time to choose a new location)
		choose_location_timer.start()
		# stop navigating 
		can_navigate = false
		return
	# the direction of the walking
	var walk_direction = (nav_agent.get_next_path_position() - global_position).normalized()
	# the velocity of the walking
	var walk_velocity = walk_direction * speed
	
	# set the agent velocity (to handle the avoidance)
	nav_agent.set_velocity(walk_velocity)
	
	
	


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	# the agent computed the velocity to avoid stucking on things
	velocity = safe_velocity
	# move and slide
	move_and_slide()


func _on_nav_timer_timeout() -> void:
	# update the target position
	nav_agent.target_position = wanted_location

func _on_choose_location_timer_timeout() -> void:
	# choose new wanted location
	wanted_location = get_next_chosen_location()
	# the minion can navigate 
	can_navigate = true
# handles the animations (not finished)

func handle_animation_and_facing() -> void:
	# Animations
	
	# play the Idle animation if static, Run if Moving
	if velocity:
		anim.play("Run", 0.2)
	else:
		anim.play("Idle", 0.2)
	
	
	# Facing
	
	
	# if going right make it look right, if left make it look left
	
	if velocity.x > 0 : texture.flip_h = false
	if velocity.x < 0 : texture.flip_h = true


# the connector of the took_damage signal from health
func _on_health_took_damage(amount: int) -> void:
	# create a damage tween, to inform the player that the minion took damage
	
	var damage_tween = create_tween()
	
	damage_tween.tween_property(texture, "modulate", Color.RED, 0.2)
	damage_tween.tween_property(texture, "modulate", Color.WHITE, 0.2)

# the connector of the died signal from health
func _on_health_died() -> void:
	# create a tween for dying
	var die_tween = create_tween()
	die_tween.tween_property(self, "scale", Vector2.ZERO, 0.4)
	# wait until the tween finish and then
	await die_tween.finished
	# free your self
	queue_free()

# when a hitbox enters the hurtbox, (this function is made to add speciallity to the minion)
func _on_hurtbox_area_entered(hit_box: HitBox) -> void:
	var direction_to_hit_box = hit_box.global_position.direction_to(global_position)
	# create a tween for the knockback
	var knock_back_tween = create_tween()
	# tween the position towards direction_to_hit_box, in 0.5 secs
	knock_back_tween.tween_property(self, "position", position + direction_to_hit_box * hit_box.knock_back_force, 0.2)
