extends State
class_name radar_mask

@onready var mask = get_parent().get_parent()
@onready var cam = mask.player.get_node("Neck/Camera3D")
@onready var radar_cam = mask.player.get_node("RadarCamera3D")
@export var campera_positon_y_increase = 10.0
@export var mask_time = 20
@export var healing = .1

#Called on equpping radar_mask mask
func Enter():
	get_parent().mask_time = mask_time #medium
	mask.player.get_node("HealingZone").process_mode = PROCESS_MODE_INHERIT
	mask.player.get_node("HealingZone/healing").play()
	#cam.position.y += campera_positon_y_increase
	#gun_type = 'normal'
	cam.current = false
	radar_cam.current = true
	
#Called on radar_mask mask timeout/new mask equipped
func Exit():
	#cam.position.y -= campera_positon_y_increase
	cam.current = true
	radar_cam.current = false
	mask.player.get_node("HealingZone/healing").stop()
	mask.player.get_node("HealingZone").process_mode = PROCESS_MODE_DISABLED
	#cam.rotation_degrees = Vector3(0, 0, 0) 
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
	mask.player.get_node("HealthManager").current_health += healing
		
func Physics_Update(_delta:float):
		cam.rotation_degrees = Vector3(0, 0, 0) 
