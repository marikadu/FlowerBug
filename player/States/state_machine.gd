extends Node

@export var initial_state: State # defining an initial state

#var current_state: State
var active_states: Array[State] = []
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)
			
	# if an initial state exists, enter it
	if initial_state:
		enter_state(initial_state)
		#initial_state.Enter()
		#current_state = initial_state

func _process(delta: float) -> void:
	#if current_state:
		#current_state.Update(delta)
	# updating a current state from the list of active states
	for state in active_states:
		state.Update(delta)
		
func _physics_process(delta: float) -> void:
	#if current_state:
		#current_state.Physics_Update(delta)
	# updating physics from the list of active states
	for state in active_states:
		state.Physics_Update(delta)
		
# the player can enter multiple states at the same time: speed, pollen multiplier
func enter_state(new_state: State):
	if new_state in active_states:
		return # if no new states, stay in the same state

	new_state.Enter() # entering new state
	active_states.append(new_state) # updating the state list

# exiting the state
func exit_state(state: State):
	if state in active_states:
		state.Exit()
		active_states.erase(state)

func _on_child_transition(state, new_state_name):
	## old system:
	#if state != current_state:
		#return
	#var new_state = states.get(new_state_name.to_lower())
	#if !new_state: # if doesn't find a new state, return
		#return
		#
	#if current_state:
		#current_state.Exit() # leaving the previous state
		#
	#new_state.Enter() # entering a new state
	#
	#current_state = new_state # changing the state
	
	var new_state = states.get(new_state_name.to_lower()) # looking for the new state to transition into
	if !new_state: # if no new states found, if the state does not exist
		return # stop, do not continue
		
	exit_state(state)
	enter_state(new_state)
