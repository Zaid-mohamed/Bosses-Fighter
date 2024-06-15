extends CharacterBody2D



@onready var player := get_tree().get_first_node_in_group("player")
# the node that handles the navigation
@onready var nav_agent: NavigationAgent2D = %NavAgent
# the timer that updates the navigation
@onready var nav_timer: Timer = %NavTimer
# the timer that chooses a new wanted location
@onready var choose_location_timer: Timer = %ChooseLocationTimer


# the min and max node positions of the wante locations
# thier positions only is used
@export var min: Marker2D
@export var max: Marker2D
###
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

var current_state : states = states.AroundPlayer


func _ready() -> void:
	wanted_location = get_next_chosen_location()
	nav_agent.set_deferred("target_position", wanted_location)
	print(nav_agent.target_position)


func _physics_process(delta: float) -> void:
	navigation()
	
# choose a location around the player with a given raduis
func get_next_chosen_location() -> Vector2:
	var rng = RandomNumberGenerator.new()
	var chosen_location = player.global_position + Vector2(rng.randf_range(-locations_radius, locations_radius),
	rng.randf_range(-locations_radius, locations_radius))
	chosen_location = clamp(chosen_location, min.global_position, max.global_position)
	
	return chosen_location

func navigation():
	if nav_agent.is_navigation_finished():
		if current_state == states.AttackingPlayer:
			nav_agent.target_position = get_next_chosen_location()
		return
	
	
	var walk_direction = (nav_agent.get_next_path_position() - global_position).normalized()
	
	var walk_velocity = walk_direction * speed
	
	
	print("")
	print("global_position : ", global_position)
	print("")
	print("target_position : ", nav_agent.target_position)
	print("")
	print("next_path_position : ", nav_agent.get_next_path_position())
	print("")
	print("walk_direction : " , walk_direction)
	print("")
	print("walk_velocity : ", walk_velocity)
	print("")
	print("wanted_location : ", wanted_location)
	
	
	nav_agent.set_velocity(walk_velocity)
	


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_nav_timer_timeout() -> void:
	nav_agent.target_position = wanted_location


func _on_choose_location_timer_timeout() -> void:
	wanted_location = get_next_chosen_location()
