extends State
class_name ice_mask

@onready var mask = get_parent().get_parent()

#Called on equpping ice mask
func Enter():
	get_parent().mask_time = 30 #long
	#gun_type = 'cold gun'
	mask.player.speed_modifier = 3.0
	mask.player.get_node("Neck/Camera3D").fov = 150.0

	
#Called on ice mask timeout/new mask equipped
func Exit():
	mask.player.speed_modifier = 1.0
	mask.player.get_node("Neck/Camera3D").fov = 75.0
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
		
func Physics_update(_delta:float):
	pass		
