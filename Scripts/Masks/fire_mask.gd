extends State
class_name fire_mask


#flamethrower deals big damage and blocks projectiles
# speed HEAVILY reduced
# DOT (to you) [shorter time limit]

@onready var mask = get_parent().get_parent()
@export var DOT = 0.1
@export var new_fov = 45.0
@export var speed_multiplier = 0.1
@export var mask_time = 10

# Stored values for resetting
var old_fov: float = 0.0

#Called on equpping fire mask
func Enter():
	get_parent().mask_time = mask_time #short
	mask.player.get_node("Flamethrower").process_mode = PROCESS_MODE_INHERIT
	mask.player.get_node("Flamethrower/burning").play()
	mask.player.get_node('Shotgun').process_mode = PROCESS_MODE_DISABLED
	mask.player.speed_modifier = speed_multiplier #10% speed
	old_fov = mask.player.get_node("Neck/Camera3D").fov
	mask.player.get_node("Neck/Camera3D").fov = new_fov


#Called on fire mask timeout/new mask equipped
func Exit():
	mask.player.get_node("Flamethrower").process_mode = PROCESS_MODE_DISABLED
	mask.player.get_node("Flamethrower/burning").stop()
	mask.player.get_node('Shotgun').process_mode = PROCESS_MODE_INHERIT
	mask.player.speed_modifier = 1.0
	mask.player.get_node("Neck/Camera3D").fov = old_fov


func Update(delta: float):
	get_parent().mask_update(delta, self)
	mask.player.get_node("HealthManager").current_health -= DOT


func Physics_Update(_delta:float):
	pass		
