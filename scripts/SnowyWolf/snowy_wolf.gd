extends CharacterBody2D

class_name SnowyWolf

enum States{ Idle, RunToPlayer, ThrowSnowBall, CopyOfShadow, SnowBallStorm, FellDown, Die }
enum Phases{ Easy, Normal, Angry }
var current_state = States.ThrowSnowBall
var current_phase = Phases.Easy
var center_location = Vector2(812, 606)
var speed = 120
@onready var player_node = $"../player"

func _process(delta: float):
	match current_state:
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
	velocity = Vector2.ZERO
	if position != center_location:
		position = center_location
	$IdleMind.start()

func run_to_player_state():
	var direction = (player_node.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func throw_snowball_state():
	velocity = Vector2.ZERO
	if position != center_location:
		position = center_location
	var player_direction = (player_node.global_position - global_position).normalized()
	var snowball_instance = preload("res://scenes/SnowyWolf/snowball.tscn").instantiate()
	get_parent().add_child(snowball_instance)
	snowball_instance.global_position = global_position
	var snowball_speed = 200 
	snowball_instance.velocity = player_direction * snowball_speed
	current_state = States.Idle

func copy_of_shadow_state():
	# Example: Implement shadow copying logic
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
			current_state = (RandomizeEasy == 0) if States.RunToPlayer else States.ThrowSnowBall
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

func _on_fell_down_timeout():
	current_state = States.Idle
