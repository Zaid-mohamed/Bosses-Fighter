## Welcome to SnowyStateMachine, this is a Dictionary of all States or Options in the Frostbite Fight, Arena.
## This is like an Resource or Something. maybe Node has all states and commands.

class_name SnowyStateMachine extends Node

## States in the state machine.
enum State{
	DECIDE, ## Decide State
	
	RUNNING_TO_PLAYER, ## First Attack
	SHORT_ATTACKING, ## After the Run (Using clew)
	
	WAVE_ATTACK, ## Second Attack
	
	SUPER_WAVE_ATTACK, ## Third Attack
	
	SNOWBALL_TRANSFORMATION, ## Fourth Attack
	
	SPAWNING_ENEMIES, ## Last Attack
	
	DYING ## Finishing The Fight.
}

## The Current State => <<State Enum>>
var current_state : State

## The Instructions to Change the Current State:
## It takes parameter <<new_state>>.
func change_state(new_state):
	if current_state == new_state:
		return
	## Firstly it disable the <<current_state>> and change it to the <<new_state>>.
	_exit_state(current_state)
	current_state = new_state
	## Finally it enters the State Tree.
	_enter_state(current_state)

## Prints something when Enter New State.
func _enter_state(state):
	match state:
		State.DECIDE:
			print("Entering Decide State")
		State.RUNNING_TO_PLAYER:
			print("Entering Running to Player State")
		State.SHORT_ATTACKING:
			print("Entering Short Attacking State")
		State.WAVE_ATTACK:
			print("Entering Wave Attacking State")
		State.SUPER_WAVE_ATTACK:
			print("Entering Super Wave Attacking State")
		State.SNOWBALL_TRANSFORMATION:
			print("Entering Snowball Transformation State")
		State.SPAWNING_ENEMIES:
			print("Entering Spawning Enemies State")
		State.DYING:
			print("Entering Dying State")

## Prints something when Exit from Current State.
func _exit_state(state):
	match state:
		State.DECIDE:
			print("Exiting Decide State")
		State.RUNNING_TO_PLAYER:
			print("Exiting Running to Player State")
		State.SHORT_ATTACKING:
			print("Exiting Short Attacking State")
		State.WAVE_ATTACK:
			print("Exiting Wave Attacking State")
		State.SUPER_WAVE_ATTACK:
			print("Exiting Super Wave Attacking State")
		State.SNOWBALL_TRANSFORMATION:
			print("Exiting Snowball Transformation State")
		State.SPAWNING_ENEMIES:
			print("Exiting Spawning Enemies State")
		State.DYING:
			print("Exiting Dying State")

## I Have moved this to The Frostbite Script. <<Frostbite.gd>> (Main Script)

#func _process(delta):
	#match current_state:
		#State.DECIDE:
			#pass
		#State.RUNNING_TO_PLAYER:
			#pass
		#State.SHORT_ATTACKING:
			#pass
		#State.SPAWNING_ENEMIES:
			#pass
		#State.TAKING_DAMAGE:
			#pass
		#State.DYING:
			#pass
