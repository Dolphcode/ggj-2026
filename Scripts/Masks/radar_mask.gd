extends State
class_name radar_mask

@onready var mask = get_parent().get_parent()
@onready var cam = mask.player.get_node("Neck/Camera3D")

#Called on equpping radar_mask mask
func Enter():
	get_parent().mask_time = 20 #medium
	#cam.rotate_x(-90)
	#cam.position.y += 10.0
	#gun_type = 'normal'
	
#Called on radar_mask mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
		
func Physics_Update(_delta:float):
	pass		
