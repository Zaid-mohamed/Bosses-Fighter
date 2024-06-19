extends CharacterBody2D

class_name SnowyWolf

# Enum(s)
enum States{ Idle, RunToPlayer, ThrowSnowBall, CopyOfShadow, SnowBallStorm, FellDown, Die }
enum Phases{ Easy, Normal, Angry }
var current_state : States = States.Idle
var current_phase : Phases = Phases.Easy


var center_location : Vector2 = Vector2(810, 634)
var run_speed : int = 160
var player_direction = null
@onready var player_node = $"../player"

signal state_changed(new_state : States)

func _ready():
	state_changed.connect(_on_snowywolf_state_changed)
	emit_signal("state_changed", States.Idle)
	
func _on_snowywolf_state_changed(new_state : States):
	
	## Manage state machine states.
	
	match new_state:
		States.Idle:
			idle_state()
		States.RunToPlayer:
			run_to_player_state()
		States.ThrowSnowBall:
			throw_snowball_state()
		States.CopyOfShadow:
			copy_of_shadow_state()
		States.SnowBallStorm:
			snowball_storm_state()
		States.FellDown:
			fell_down_state()
		States.Die:
			die_state()

func idle_state():
	# Boss can't move:
	velocity = Vector2.ZERO
	
	# Put the boss the center of the arena.
	if position != center_location:
		position = center_location
	
	# State the Changer decide timer. 
	$IdleMind.start(2.5)
	
	# Reset the player direction.
	player_direction = null

func run_to_player_state():
	## Decide the direction to move to, one line.
	if player_direction == null:
		player_direction = (player_node.global_position - global_position).normalized()
	
	velocity = player_direction * run_speed
	
	move_and_slide()
	
	## if Collide with a wall, will fell down, then the player can damage it.
	##
	## DON'T TOUCH IT NOW, WHEN I FINISHED
	current_state = States.Idle # Fell Down
	emit_signal("state_changed", current_state)
	
func throw_snowball_state():
	# Boss can't move:
	velocity = Vector2.ZERO
	
	# Put the boss the center of the arena.
	if position != center_location:
		position = center_location
	
	# Decide the player direction to throw the snowball.
	player_direction = (player_node.global_position - global_position).normalized()
	
	# Snowball Instantiate Configure
	var snowball_instance = preload("res://scenes/SnowyWolf/snowball.tscn").instantiate()
	get_parent().add_child(snowball_instance)
	
	snowball_instance.global_position = global_position
	
	var snowball_speed = 200 
	snowball_instance.velocity = player_direction * snowball_speed
	
	# Change the state to The IDLE again.
	current_state = States.Idle
	emit_signal("state_changed", current_state)

func copy_of_shadow_state():
	pass

func snowball_storm_state():
	# Example: Implement snowball storm logic
	pass

func fell_down_state():
	# Example: Implement fell down behavior
	pass

func die_state():
	# Example: Implement die behavior
	pass

func _on_idle_mind_timeout():
	match current_phase:
		Phases.Easy:
			var RandomizeEasy = randi_range(0, 1)
			match RandomizeEasy:
				0: current_state = States.RunToPlayer
				1: current_state = States.ThrowSnowBall
		Phases.Normal:
			var RandomizeNormal = randi_range(0, 4)
			match RandomizeNormal:
				0: current_state = States.RunToPlayer
				1: current_state = States.ThrowSnowBall
				_: current_state = States.CopyOfShadow
		Phases.Angry:
			var RandomizeAngry = randi_range(0, 8)
			match RandomizeAngry:
				0: current_state = States.RunToPlayer
				1: current_state = States.ThrowSnowBall
				2, 3: current_state = States.CopyOfShadow
				_: current_state = States.SnowBallStorm
	emit_signal("state_changed", current_state)

func _on_fell_down_timeout():
	current_state = States.Idle
	emit_signal("state_changed", current_state)
