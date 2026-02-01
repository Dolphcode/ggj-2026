extends Node

@export var initial_state : State

var current_state : State
var mask_time : float
var gun_type : String
var mask_queue = ['fire_mask', 'rage_mask', 'radar_mask', 'ice_mask']
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		
func _process(delta):
	if current_state:
		current_state.Update(delta)
		
		
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	current_state = new_state
	
	
func mask_update(delta: float, mask):
	#	decreases mask time until it reaches 0
	if mask_time > 0:
		mask_time -= delta
	else:
		on_child_transition(mask, 'no_mask')


#class_name fire_mask

func on_mask_pickup(mask):
	mask_queue.append(mask)

func is_queue_full():
	return mask_queue >= 3
