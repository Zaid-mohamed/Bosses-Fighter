extends CharacterBody2D

class_name SnowyWolf

# Constants Of State Machine
enum States{Idle, RunToPlayer, ThrowSnowBall, CopyOfShadow, SnowBallStorm, FellDown, Die}

# Boss's Phases
enum Phases{Easy, Normal, Angry}

# Current State
var current_state = States.Idle

# Current Phase
var current_phase = Phases.Easy

# Center Location Of The Arena.
var center_location = Vector2(812, 606)

# Player Node
@onready var player_node = $"../player"


# Process Function
func _process(delta: float):
	pass

# Change Phase to Harder One
#func select_phase(next_phase: Phases):
#pass
#
# Change State to The Next State
#func change_state(next_state: States):
#pass

# Idle State
func idle_state():
	velocity = Vector2.ZERO
	if position != center_location:
		position = center_location
	$IdleMind.start()
	pass

# RunToPlayer State
func run_to_player_state():
	pass

# ThrowSnowBall State
func throw_snowball_state():
	pass

# CopyOfShadow State
func copy_of_shadow_state():
	pass

# SnowBallStorm State
func snowball_storm_state():
	pass

# Fell Down State
func fell_down_state():
	pass

# Die State
func die_state():
	pass

# Idle Mind Timeout Function/Signal.
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
				2 || 3: current_state = States.CopyOfShadow
				_: current_state = States.SnowBallStorm
	pass

# Fell Down Timeout Function/Signal.
func _on_fell_down_timeout():
	current_state = States.Idle
	pass
