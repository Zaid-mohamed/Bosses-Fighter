class_name Frostbite extends CharacterBody2D

## Variables for The nodes.
@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape2D
@onready var attack_timer = $Attackcooldown
@onready var spawn_timer = $Spawncooldown
@onready var animation_player = $AnimationPlayer
@onready var state_machine = $SnowyStateMachine

## Settings.
@export_category("Settings")
@export var accel : int = 28
@export var decel : int = 35
@export var max_speed : int = 120
@export var max_health : int = 320

var health : int = 100

## Randomization.
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

## Player Node.
@export var player : Player

## Phases Index.
var phase_index : int = 0

var current_phase : Dictionary

## Phase Machine.
var Phases : Array = [
	## Easy
	{
		0 : SnowyStateMachine.State.RUNNING_TO_PLAYER,
		1 : SnowyStateMachine.State.WAVE_ATTACK,
	},
	
	## Medium
	{
		0 : SnowyStateMachine.State.RUNNING_TO_PLAYER,
		1 : SnowyStateMachine.State.WAVE_ATTACK,
		2 : SnowyStateMachine.State.SPAWNING_ENEMIES,
	},
	
	## Hard
	{
		0 : SnowyStateMachine.State.RUNNING_TO_PLAYER,
		1 : SnowyStateMachine.State.WAVE_ATTACK,
		2 : SnowyStateMachine.State.SPAWNING_ENEMIES,
		3 : SnowyStateMachine.State.SUPER_WAVE_ATTACK,
	},
	
	## Angry
	{
		0 : SnowyStateMachine.State.RUNNING_TO_PLAYER,
		1 : SnowyStateMachine.State.WAVE_ATTACK,
		2 : SnowyStateMachine.State.SPAWNING_ENEMIES,
		3 : SnowyStateMachine.State.SUPER_WAVE_ATTACK,
		4 : SnowyStateMachine.State.SNOWBALL_TRANSFORMATION,
	},
]

func _ready() -> void:
	## Set State -> Decide (on Start).
	state_machine.change_state(SnowyStateMachine.State.DECIDE)
	
	## Randomization.
	randomize()
	rng.seed = randi()

func _process(delta: float) -> void:
	## Manage current State.
	
	match state_machine.current_state:
		SnowyStateMachine.State.DECIDE:
			_decide_state(delta)
			
		SnowyStateMachine.State.RUNNING_TO_PLAYER:
			_running_to_player_state(delta)
			
		SnowyStateMachine.State.SHORT_ATTACKING:
			_attacking_state(delta)
		
		SnowyStateMachine.State.WAVE_ATTACK:
			pass
		
		SnowyStateMachine.State.SUPER_WAVE_ATTACK:
			pass
		
		SnowyStateMachine.State.SNOWBALL_TRANSFORMATION:
			pass
		
		SnowyStateMachine.State.SPAWNING_ENEMIES:
			_spawning_enemies_state(delta)
			
		SnowyStateMachine.State.TAKING_DAMAGE:
			_taking_damage_state(delta)
			
		SnowyStateMachine.State.DYING:
			_dying_state(delta)

func _physics_process(delta: float) -> void:
	
	move_and_slide()

## Decide State.
func _decide_state(delta):
	if player:
		current_phase = Phases[phase_index]
		
			
	if player:
		state_machine.change_state(SnowyStateMachine.State.RUNNING_TO_PLAYER) ## Editing -> Another States.

## Run Toward Player State.
func _running_to_player_state(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		
		velocity += direction * max_speed
		
		if global_position.distance_to(player.global_position) < 50:
			state_machine.change_state(SnowyStateMachine.State.SHORT_ATTACKING)

## Short Attack State.
func _attacking_state(delta):
	animation_player.play("ShortAttack")

## Spawn Minions.
func _spawning_enemies_state(delta):
	## Spawning Information.
	
	## On Finish Spawning -> :-
	state_machine.change_state(SnowyStateMachine.State.DECIDE)

## Take Damage State.
func _taking_damage_state(delta):
	## Play Flash Damage Animation.################################################################
	
	if health <= 0:
		state_machine.change_state(SnowyStateMachine.State.DYING)
	else:
		state_machine.change_state(SnowyStateMachine.State.DECIDE)

## Take Damage by Player Control :-
func take_damage(amount):
	health -= amount
	state_machine.change_state(SnowyStateMachine.State.TAKING_DAMAGE)

## the End of fight.
func _dying_state(delta):
	## This will be an animation
	queue_free()

## Editing....
func _on_attackcooldown_timeout() -> void:
	state_machine.change_state(SnowyStateMachine.State.SHORT_ATTACKING)

## Editing....
func _on_spawncooldown_timeout() -> void:
	state_machine.change_state(SnowyStateMachine.State.SPAWNING_ENEMIES)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ShortAttack":
		state_machine.change_state(SnowyStateMachine.State.DECIDE)
