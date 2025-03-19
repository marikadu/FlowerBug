extends Node

@export var initial_state: State # defining an initial state

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)
			
	# if an initial state exists, enter it
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)
		

func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: # if doesn't find a new state, return
		return
		
	if current_state:
		current_state.Exit() # leaving the previous state
		
	new_state.Enter() # entering a new state
	
	current_state = new_state # changing the state
