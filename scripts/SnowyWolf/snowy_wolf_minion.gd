extends CharacterBody2D



@onready var player := get_tree().get_first_node_in_group("player")
# the node that handles the navigation
@onready var nav_agent: NavigationAgent2D = %NavAgent
# the timer that updates the navigation
@onready var nav_timer: Timer = %NavTimer

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




func _ready() -> void:
	nav_agent.target_position = player.global_position
	wanted_location = get_next_chosen_location()
	nav_timer.start()

# choose a location around the player with a given raduis
func get_next_chosen_location() -> Vector2:
	var rng = RandomNumberGenerator.new()
	var chosen_location = Vector2(rng.randf_range(-locations_radius, locations_radius),
	rng.randf_range(-locations_radius, locations_radius))
	
	return chosen_location


func navigation():
	if nav_agent.is_navigation_finished():
		return
	var walk_direction = (nav_agent.get_next_path_position() - global_position).normalized()
	var walk_velocity = walk_direction * speed
	
	nav_agent.set_velocity(walk_velocity)
	
	


func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_nav_timer_timeout() -> void:
	nav_agent.target_position = player.global_position
