extends State
class_name rage_mask



#Called on equpping rage mask
func Enter():
	pass
	#mask_time = 20 #medium
	#gun_type = 'normal' #note that this gun will be mega buffed
	
#Called on rage mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta)
		
func Physics_Update(_delta:float):
	pass		
