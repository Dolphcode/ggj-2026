extends State
class_name radar_mask



#Called on equpping radar_mask mask
func Enter():
	pass
	#mask_time = 20 #medium
	#gun_type = 'normal'
	
#Called on radar_mask mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta)
		
func Physics_Update(_delta:float):
	pass		
