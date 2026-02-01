extends State
class_name schitzo_mask



#Called on equpping schitzo mask
@export var mask_time = 30


func Enter():
	get_parent().mask_time = mask_time #long
	#gun_type = 'normal'
	
#Called on schitzo mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
		
func Physics_Update(_delta:float):
	pass		
