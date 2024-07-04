class_name Frostbite extends CharacterBody2D

## Variables for The nodes.
@onready var spawn_timer = $Spawncooldown
@onready var animation_player = $AnimationPlayer
@onready var state_machine = $Statemachine
@onready var health_component = $Healthcomponent
@onready var hurtbox = $Hurtbox

## Settings.
@export_category("Settings")
@export var accel : int = 28
@export var decel : int = 35
@export var max_speed : int = 120

var health : int 

## Player Node.
@export var player : Player

## Phase Variables
var phase_index : int = 0
var current_phase : Dictionary
var current_attack

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
	## Randomization.
	randomize()
	
	health = health_component.current_health
	
	## Initialize Current Phase.
	_initialize_phase()

func _process(delta: float) -> void:
	## Manage current State.
	
	match state_machine.current_state:
		SnowyStateMachine.State.DECIDE:
			_decide_state(delta)
			
		SnowyStateMachine.State.RUNNING_TO_PLAYER:
			_running_to_player_state(delta)
			
		SnowyStateMachine.State.SHORT_ATTACKING:
			_short_attacking_state(delta)
		
		SnowyStateMachine.State.WAVE_ATTACK:
			_wave_attack_state(delta)
		
		SnowyStateMachine.State.SUPER_WAVE_ATTACK:
			_super_wave_attack_state(delta)
		
		SnowyStateMachine.State.SNOWBALL_TRANSFORMATION:
			_transformation_state(delta)
		
		SnowyStateMachine.State.SPAWNING_ENEMIES:
			_spawning_enemies_state(delta)
			
		SnowyStateMachine.State.DYING:
			_dying_state(delta)

func _physics_process(delta: float) -> void:
	move_and_slide()

func _set_phase_index(index: int):
	if phase_index != index:
		phase_index = index
		_initialize_phase()
	
	else:
		return

## Initialize Current Phase.
func _initialize_phase() -> void:
	current_phase = Phases[phase_index]
	state_machine.change_state(SnowyStateMachine.State.DECIDE)

## Change Current Phase (Based on Health Component)
func _manage_phases() -> void:
	if health > 240:
		_set_phase_index(0)
	elif health > 160 && health < 240:
		_set_phase_index(1)
	elif health > 80 && health < 160:
		_set_phase_index(2)
	else:
		_set_phase_index(3)

## Decide State.
func _decide_state(delta):
	if player:
		var avilable_attacks = current_phase.values()
		
		var randomization = randi() % avilable_attacks.size()
		
		current_attack = avilable_attacks[randomization]
		
		_manage_phases()
		
		state_machine.change_state(current_attack)

## Run Toward Player State.
func _running_to_player_state(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		
		velocity = direction * max_speed
		
		if global_position.distance_to(player.global_position) < 50:
			state_machine.change_state(SnowyStateMachine.State.SHORT_ATTACKING)
			velocity = Vector2.ZERO

## Short Attack State.
func _short_attacking_state(delta):
	$AttackRegion.look_at(player.global_position)
	animation_player.play("ShortAttack")

func _on_attack_region_body_entered(body: Node2D) -> void:
	if body is Player && body.has_method("Damage"):
		pass

func _wave_attack_state(delta):
	pass

func _super_wave_attack_state(delta):
	pass

func _transformation_state(delta):
	pass

## Spawn Minions.
func _spawning_enemies_state(delta):
	## Spawning Information.
	
	## On Finish Spawning -> :-
	state_machine.change_state(SnowyStateMachine.State.DECIDE)

## I am Waiting to finish the Spawning Mecanic <<Minions>>
func _on_spawncooldown_timeout() -> void:
	pass

## the End of fight.
func _dying_state(delta):
	## This will be an animation
	queue_free()

## When The Animation Finished, Do Something.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ShortAttack":
		state_machine.change_state(SnowyStateMachine.State.DECIDE)

## When Take Damage This Signal will emitted.
func _on_healthcomponent_took_damage(amount: int) -> void:
	print("Took damage: %d" % amount)

## If the Health < Or = 0, The Boss will Die
func _on_healthcomponent_died() -> void:
	state_machine.change_state(SnowyStateMachine.State.DYING)

## Else: Change to Decide State.
func _on_healthcomponent_decide() -> void:
	state_machine.change_state(SnowyStateMachine.State.DECIDE)

## hit Signal from <<Hurtbox.gd>>
func _on_hurtbox_hit(damage : int) -> void:
	## First it Apply the Damage in Health Component.
	health_component.take_damage(damage)
	
	## Play <<Damage Flash Animation>>
	animation_player.play("TakeDamage")
