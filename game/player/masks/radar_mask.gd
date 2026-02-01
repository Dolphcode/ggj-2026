extends State
class_name radar_mask

@onready var mask = get_parent().get_parent()
@onready var cam = mask.player.get_node("Neck/Camera3D")
@onready var radar_cam = mask.player.get_node("RadarCamera3D")


@export var mask_time = 20
@export var healing = .1

#Called on equpping radar_mask mask
func Enter():
	get_parent().mask_time = mask_time #medium
	AudioManager.get_node("RadarEquip").play()
	mask.player.get_node("HealingZone/HealingArea3D").set_deferred("collision_mask", 0x2)
	mask.player.get_node("HealingZone/healing").play()
	cam.current = false
	radar_cam.current = true


#Called on radar_mask mask timeout/new mask equipped
func Exit():
	# Turns out just changing the collision mask to stop detecting
	# bodies also means bodies that were previously detected now exit the area
	# NEATO!
	mask.player.get_node("HealingZone/HealingArea3D").set_deferred("collision_mask", 0x0)
	cam.current = true
	radar_cam.current = false
	mask.player.get_node("HealingZone/healing").stop()
	mask.player.get_node("HealingZone").process_mode = PROCESS_MODE_DISABLED


func Update(delta: float):
	get_parent().mask_update(delta, self)
	mask.player.get_node("HealthManager").current_health += healing
	cam.rotation_degrees = Vector3(0, 0, 0) 
	radar_cam.rotation.z = cam.get_parent().rotation.y


func Physics_Update(_delta:float):
	pass
