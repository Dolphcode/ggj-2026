extends State
class_name ice_mask

@onready var mask = get_parent().get_parent()

#Called on equpping ice mask
func Enter():
	#mask_time = 30 #long
	#gun_type = 'cold gun'
	mask.player.speed_modifier = 3.0
	
#Called on ice mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta)
		
func Physics_update(_delta:float):
	pass		
