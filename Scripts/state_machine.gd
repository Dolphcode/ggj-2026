extends Node

@export var initial_state : State

var current_state : State
var mask_time : float
var gun_type : String
var mask_queue = ['ice_mask', 'rage_mask', 'radar_mask', 'ice_mask']
#var mask_queue = []
var states : Dictionary = {}

#UI variables for ease and save on overhead
@onready var interface:Control = get_node("../../HUD/UserInterface")
@onready var mask_rect:ColorRect = interface.get_node("MaskRect")
@onready var mask_label:Label = mask_rect.get_node("MaskLabel")
@onready var score_label:Label = interface.get_node("ScoreLabel")

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
	
	match new_state_name:
		"fire_mask":
			mask_rect.color = 0xff000080
			mask_label.text = "Fire Mask"
		"ice_mask":
			mask_rect.color = 0x0000ff80
			mask_label.text = "Ice Mask"
		"radar_mask":
			mask_rect.color = 0x00ff0080
			mask_label.text = "Radar Mask"
		"rage_mask":
			mask_rect.color = 0x00000080
			mask_label.text = "Rage Mask"
		_:
			mask_rect.color = 0x99999980
			mask_label.text = "No Mask"
	
func mask_update(delta: float, mask):
	#	decreases mask time until it reaches 0
	if mask_time > 0:
		mask_time -= delta
	else:
		get_parent().player.get_node("MaskPowerDown").play()
		on_child_transition(mask, 'no_mask')


#class_name fire_mask

func _on_mask_pick_up(mask):
	get_parent().player.get_node("MaskPickup").play()
	mask_queue.append(mask)
	#print(mask_queue)
	#print("added ", mask)

func is_queue_full():
	return mask_queue >= 3
