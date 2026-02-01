extends State
class_name ice_mask

@onready var mask = get_parent().get_parent()
@export var mask_time = 30
@export var speed_modifier = 3.0
@export var new_fov = 150.0
#Called on equpping ice mask
func Enter():
	get_parent().mask_time = mask_time #long
	#gun_type = 'cold gun'
	mask.player.speed_modifier = speed_modifier
	mask.player.get_node("Neck/Camera3D").fov = new_fov

	
#Called on ice mask timeout/new mask equipped
func Exit():
	mask.player.speed_modifier = 1.0
	mask.player.get_node("Neck/Camera3D").fov = 75.0
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
		
func Physics_update(_delta:float):
	pass		
