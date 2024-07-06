extends CharacterBody2D

class_name FireyDeek

@export var max_speed: float
@export var accel: float
@export var decel: float
@export var arena_center: Marker2D
@export var aim: float = 0.2
@export var max_bullets: int = 5
var current_bullets: int = max_bullets
@onready var thinking_timer: Timer = %ThinkingTimer
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var minkar: Marker2D = %Minkar
@onready var shooting_timer: Timer = %ShootingTimer
@onready var wave_shoot_indicator: Marker2D = %WaveShootIndicator

enum states {
	Thinking, # in this state the deek will think what attack it will do.
	ThrowingFireyBalls, # in this state the deek will throw fire balls towards the player.
	FireBallsWave, # in this state the deek will make a wave of fire balls towards everywhere.
	BurnedAttack, # in this state the deek will fire up him self and run towards the player
	SpawningWives, # in this state the deek will spawn his wifes.
	OrderingWivesToSpawn, # in this state the deek will order his wives to spawn some katakeet
	Dying # this is the state of the deek dying.
}

# the current_state of the deek
var current_state: states
# the index of the current phase
var phase_index: int = 1

# the phases
var phases : Array[Dictionary] = [
	# the first phase
	{
		0: states.ThrowingFireyBalls
	},
	# the second phase
	{
		0: states.ThrowingFireyBalls,
		1: states.FireBallsWave,
		#2: states.OrderingWivesToSpawn
		
	},
	# the last phase
	{
		0: states.ThrowingFireyBalls,
		1: states.FireBallsWave,
		2: states.BurnedAttack
	}
]

var shooting_wave_state: bool = false
func _ready() -> void:
	current_state = states.Thinking
func _physics_process(delta: float) -> void:
	match current_state:
		states.Thinking:
			thinking_state()
		states.ThrowingFireyBalls:
			throwing_firey_balls_state()
		states.FireBallsWave:
			if !shooting_wave_state:
				
				fire_balls_wave_state()
		states.BurnedAttack:
			burned_attack_state()
		states.SpawningWives:
			spawning_wives_state()
		states.OrderingWivesToSpawn:
			ordering_wives_to_spawn_state()
			

# changes the state.
func change_state(new_state: states):
	shooting_timer.stop()
	if new_state == current_state: return
	current_state = new_state
	print("new_state : ", current_state)
func thinking_state():
	if !thinking_timer.is_stopped(): print("Thinking...")
	if thinking_timer.is_stopped():
		
		thinking_timer.start()
		print("thinking_timer started")
	

func _on_thinking_timer_timeout() -> void:
	choose_attack()
	print("thinking timer ended")
	
# chooses an attack
func choose_attack():
	# Create a number generator
	var rng = RandomNumberGenerator.new()
	# choose an attack state
	var chosen_attack = phases[phase_index][rng.randi_range(0, phases[phase_index].size() - 1)]
	# change the state to this chosen attck state
	change_state(chosen_attack)

func throwing_firey_balls_state():
	# move to center
	global_position = arena_center.global_position
	# start the shooting timer if not already started
	if shooting_timer.is_stopped():
		shooting_timer.start()


# ran when shooting timer timeout
func shoot_firey_ball():
	print("shot")
	var direction_to_player = global_position.direction_to(player.global_position)
	var fire_ball_scene = preload("res://scenes/Deek/deek_fire_ball.tscn")
	var fire_ball_instance = fire_ball_scene.instantiate()
	# set the correct velocity
	fire_ball_instance.velocity = (direction_to_player * fire_ball_instance.speed).rotated(randf_range(-aim, aim))
	# put the ball in the correct position
	fire_ball_instance.global_position =  minkar.global_position
	# add it
	get_tree().root.add_child(fire_ball_instance)
	current_bullets -= 1
	if current_bullets == 0:
		current_bullets = max_bullets
		change_state(states.Thinking)
func shoot_firey_ball_with_direction(direction: Vector2):
	print("shot")
	var direction_to_player = global_position.direction_to(player.global_position)
	var fire_ball_scene = preload("res://scenes/Deek/deek_fire_ball.tscn")
	var fire_ball_instance = fire_ball_scene.instantiate()
	# set the correct velocity
	fire_ball_instance.velocity = (direction * fire_ball_instance.speed).rotated(randf_range(-aim, aim))
	# put the ball in the correct position
	fire_ball_instance.global_position =  minkar.global_position
	# add it
	get_tree().root.add_child(fire_ball_instance)
func fire_balls_wave_state():
	shooting_wave_state = true
	for shot in 30:
		await get_tree().create_timer(0.2).timeout
		shoot_firey_ball_with_direction(minkar.global_position.direction_to(wave_shoot_indicator.global_position))
		minkar.rotate(0.5)
	
	shooting_wave_state = false
	change_state(states.Thinking)
func spawning_wives_state():
	pass


func ordering_wives_to_spawn_state():
	pass
func burned_attack_state():
	pass
func dying_state():
	pass

