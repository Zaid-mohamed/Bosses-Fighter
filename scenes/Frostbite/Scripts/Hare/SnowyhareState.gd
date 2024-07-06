class_name SnowyhareState extends Node

enum State{
	DECIDE, ## Decide State
	
	DASH, ## Dash Toward State
	
	DYING ## Finishing The Fight.
}

## The Current State => <<State Enum>>
var current_state : State

## The Instructions to Change the Current State:
## It takes parameter <<new_state>>.
func change_state(new_state):
	if current_state == new_state:
		return
	
	current_state = new_state
