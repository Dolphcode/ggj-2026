extends State
class_name fire_mask


#flamethrower deals big damage and blocks projectiles
# speed HEAVILY reduced
# DOT (to you) [shorter time limit]

@onready var mask = get_parent().get_parent()

#Called on equpping fire mask
func Enter():
	#mask_time = 10 #short
	#gun_type = 'flamethrower'
	mask.player.speed_modifier = 0.1 #10% speed
#Called on fire mask timeout/new mask equipped
func Exit():
	pass
	
func Update(delta: float):
	get_parent().mask_update(delta)
		
func Physics_Update(_delta:float):
	pass		
