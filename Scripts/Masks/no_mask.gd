extends State
class_name no_mask

#State for when the player is not wearing a mask
#Stats are 'normal' until player equips a mask

@onready var mask = get_parent().get_parent()



#Called on start of game or losing mask
func Enter():
	#gun_type = 'normal'
	mask.player.speed_modifier = 1.0
	
#Called on equpping a mask
func Exit():
	pass
	
func Update(delta: float):
		#	equip the next mask in the queue
	if Input.is_action_just_pressed('equip_mask'):
		var mask_queue = get_parent().mask_queue
		if mask_queue:
			print('equip_mask')
			print(mask_queue)
			var mask_to_equip = mask_queue.pop_front() 
			print(mask_queue)
			print(mask_to_equip)
			Transitioned.emit(self, mask_to_equip)
			#previous_state = mask_to_equip
		
func Physics_Update(_delta:float):
	pass		
