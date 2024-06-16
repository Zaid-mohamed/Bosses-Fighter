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
@export var speed : float
# the raduis of the locations chosen around the player
@export var locations_radius : float

# the location the minion going to currently
var wanted_location : Vector2
# the states according to its distance from player.
enum states {
	AroundPlayer,
	AttackingPlayer
}


# the current state of the minion
var current_state : states = states.AroundPlayer


func _ready() -> void:
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
	# clamp the chosen location to avoid choosing a position outside the map 
	chosen_location = clamp(chosen_location, min.global_position, max.global_position)
	# return this randomized chosen location
	return chosen_location
	
	

func navigation() -> void:
	# the minion reached the wanted position, stop
	if nav_agent.is_navigation_finished():
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
	print("nav_timer timeout")

func _on_choose_location_timer_timeout() -> void:
	# choose new wanted location
	wanted_location = get_next_chosen_location()
	print("choose_location_timer timeout")
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
