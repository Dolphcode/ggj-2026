extends State
class_name schitzo_mask



#Called on equpping schitzo mask
func Enter():
	pass
	#mask_time = 30 #long
	#gun_type = 'normal'
	
#Called on schitzo mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta)
		
func Physics_Update(_delta:float):
	pass		
