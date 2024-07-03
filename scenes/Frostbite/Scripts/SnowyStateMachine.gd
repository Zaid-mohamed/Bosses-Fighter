class_name SnowyStateMachine extends Node

enum State{
	DECIDE,
	
	RUNNING_TO_PLAYER,
	SHORT_ATTACKING,
	
	WAVE_ATTACK,
	
	SUPER_WAVE_ATTACK,
	
	SNOWBALL_TRANSFORMATION,
	
	SPAWNING_ENEMIES,
	
	TAKING_DAMAGE,
	DYING
}

var current_state

func change_state(new_state):
	if current_state == new_state:
		return
	_exit_state(current_state)
	current_state = new_state
	_enter_state(current_state)

func _enter_state(state):
	match state:
		State.DECIDE:
			print("Entering Decide State")
		State.RUNNING_TO_PLAYER:
			print("Entering Running to Player State")
		State.SPAWNING_ENEMIES:
			print("Entering Spawning Enemies State")
		State.SHORT_ATTACKING:
			print("Entering Short Attacking State")
		State.TAKING_DAMAGE:
			print("Entering Taking Damage State")
		State.DYING:
			print("Entering Dying State")

func _exit_state(state):
	match state:
		State.DECIDE:
			print("Exiting Decide State")
		State.RUNNING_TO_PLAYER:
			print("Exiting Running to Player State")
		State.SPAWNING_ENEMIES:
			print("Exiting Spawning Enemies State")
		State.SHORT_ATTACKING:
			print("Exiting Short Attacking State")
		State.TAKING_DAMAGE:
			print("Exiting Taking Damage State")
		State.DYING:
			print("Exiting Dying State")

func _process(delta):
	match current_state:
		State.DECIDE:
			pass
		State.RUNNING_TO_PLAYER:
			pass
		State.SHORT_ATTACKING:
			pass
		State.SPAWNING_ENEMIES:
			pass
		State.TAKING_DAMAGE:
			pass
		State.DYING:
			pass
