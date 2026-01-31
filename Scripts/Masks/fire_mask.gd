extends State
class_name fire_mask


#flamethrower deals big damage and blocks projectiles
# speed HEAVILY reduced
# DOT (to you) [shorter time limit]

@onready var mask = get_parent().get_parent()

#Called on equpping fire mask
func Enter():
	get_parent().mask_time = 10 #short
	#gun_type = 'flamethrower'
	mask.player.speed_modifier = 0.1 #10% speed
	mask.player.get_node("Neck/Camera3D").fov = 45.0
#Called on fire mask timeout/new mask equipped
func Exit():
	mask.player.speed_modifier = 1.0
	mask.player.get_node("Neck/Camera3D").fov = 75.0
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
		
func Physics_Update(_delta:float):
	pass		
