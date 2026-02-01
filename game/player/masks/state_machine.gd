extends Node
class_name MaskHandler

@export var initial_state : State

var current_state : State
var mask_time : float
var gun_type : String
var mask_queue = ['rage_mask']
var states : Dictionary = {}

#UI variables for ease and save on overhead
@onready var interface:Control = get_node("../../HUD/UserInterface")
@onready var mask_rect:ColorRect = interface.get_node("MaskRect")
@onready var mask_label:Label = mask_rect.get_node("MaskLabel")
@onready var score_label:Label = interface.get_node("ScoreLabel")
@onready var mask_queue_HUD:VBoxContainer = interface.get_node("MaskQueue")

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
	color_queue()
		

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
	color_rect(new_state_name, mask_rect)
	
func mask_update(delta: float, mask):
	#	decreases mask time until it reaches 0
	if mask_time > 0:
		mask_time -= delta
	else:
		get_parent().player.get_node("MaskPowerDown").play()
		on_child_transition(mask, 'no_mask')

func color_rect(x, current_rect):
	match x:
		"fire_mask":
			current_rect.color = 0xff000080
			current_rect.get_node("MaskLabel").text = "Fire Mask"
		"ice_mask":
			current_rect.color = 0x0000ff80
			current_rect.get_node("MaskLabel").text = "Ice Mask"
		"radar_mask":
			current_rect.color = 0x00ff0080
			current_rect.get_node("MaskLabel").text = "Radar Mask"
		"rage_mask":
			current_rect.color = 0x00000080
			current_rect.get_node("MaskLabel").text = "Rage Mask"
		_:
			current_rect.color = 0x99999980
			current_rect.get_node("MaskLabel").text = "No Mask"
			
func color_queue():
	var count = 0
	for mask in mask_queue:
		color_rect(mask, mask_queue_HUD.get_node("Mask" + str(count)))
		count += 1
	while(count < 3):
		color_rect("no_mask", mask_queue_HUD.get_node("Mask" + str(count)))
		count += 1

func is_queue_full():
	return len(mask_queue) >= 3


func _on_player_die() -> void:
	on_child_transition(current_state, "no_mask")
