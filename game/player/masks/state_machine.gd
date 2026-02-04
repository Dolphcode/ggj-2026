extends Node
class_name MaskHandler

@export var initial_state : State

@export_category("Slots")
@export var slots: Array[TextureRect]
@export var mask_rect: TextureRect
@export var rage_icon: Texture
@export var fire_icon: Texture
@export var ice_icon: Texture
@export var radar_icon: Texture
@export var blank_icon: Texture
@export var mask_timer: Slider

var current_state : State
var mask_time : float
var gun_type : String
var mask_queue = []
var states : Dictionary = {}

#UI variables for ease and save on overhead
@onready var interface:Control = get_node("../../HUD/UserInterface")
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	mask_timer.visible = false
		
func _process(delta):
	if current_state:
		current_state.Update(delta)
	color_queue()


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
	color_rect(new_state_name, mask_rect)
	
func mask_update(delta: float, mask):
	#	decreases mask time until it reaches 0
	if mask_time > 0:
		mask_time -= delta
		mask_timer.value = mask_time
	else:
		get_parent().player.get_node("MaskPowerDown").play()
		mask_timer.visible = false
		on_child_transition(mask, 'no_mask')

func color_rect(x, current_rect: TextureRect):
	match x:
		"fire_mask":
			current_rect.texture = fire_icon
		"ice_mask":
			current_rect.texture = ice_icon
		"radar_mask":
			current_rect.texture = radar_icon
		"rage_mask":
			current_rect.texture = rage_icon
		_:
			current_rect.texture = blank_icon
			
func color_queue():
	var count = 0
	for mask in mask_queue:
		color_rect(mask, slots[count])
		count += 1
	while(count < 3):
		color_rect("no_mask", slots[count])
		count += 1

func is_queue_full():
	return len(mask_queue) >= 3


func _on_player_die() -> void:
	on_child_transition(current_state, "no_mask")
