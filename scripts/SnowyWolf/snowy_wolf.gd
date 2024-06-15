extends CharacterBody2D

class_name SnowyWolf

# Constants Of State Machine
enum States{Idle, RunToPlayer, ThrowSnowBall, CopyOfShadow, SnowBallStorm, Die}

# Boss's Phases
enum Phases{Easy, Normal, Angry}

# Current State
var current_state = States.Idle

# Current Phase
var current_phase = Phases.Easy

# Health Section
const max_health = 350

var health = max_health

# Process Function
func _process(delta: float):
	pass

# Change Phase to Harder One
func select_phase(next_phase: Phases):
	pass

# Change State to The Next State
func change_state(next_state: States):
	pass

# Idle State
func idle_state():
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

# Die State
func die_state():
	pass

# Idle Mind Timeout Function/Signal.
func _on_idle_mind_timeout():
	pass

# Fell Down Timeout Function/Signal.
func _on_fell_down_timeout():
	pass
