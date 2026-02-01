extends State
class_name ice_mask

@onready var mask = get_parent().get_parent()
@export var mask_time = 30
@export var speed_multiplier = 3.0
@export var new_fov = 150.0
@onready var world_environment:WorldEnvironment = mask.player.get_node("../WorldEnvironment")

@onready var double_barrel_model: Node3D = get_parent().get_parent().get_parent().get_node("Neck/Camera3D/doublebarrel")
@onready var ice_barrel_model: Node3D = get_parent().get_parent().get_parent().get_node("Neck/Camera3D/icebarrel")

var old_decel_default: float = 0.0
var old_decel_slide: float = 0.0
var old_fov: float = 0.0

#Called on equpping ice mask
func Enter():
	double_barrel_model.visible = false
	ice_barrel_model.visible = true
	old_decel_default = mask.player.DECELERATION_DEFAULT
	old_decel_slide = mask.player.DECELERATION_SLIDE
	old_fov = mask.player.get_node("Neck/Camera3D").fov
	AudioManager.get_node("IceEquip").play()
	get_parent().mask_time = mask_time #long
	mask.player.get_node("FrozenShotgun").process_mode = PROCESS_MODE_INHERIT
	mask.player.get_node('Shotgun').process_mode = PROCESS_MODE_DISABLED
	mask.player.speed_modifier = speed_multiplier
	mask.player.DECELERATION_DEFAULT = 0.1
	mask.player.DECELERATION_SLIDE = 0.0
	mask.player.get_node("Neck/Camera3D").fov = new_fov
	world_environment.environment.fog_enabled = false

	
#Called on ice mask timeout/new mask equipped
func Exit():
	double_barrel_model.visible = true
	ice_barrel_model.visible = false
	mask.player.get_node("FrozenShotgun").process_mode = PROCESS_MODE_DISABLED
	mask.player.get_node('Shotgun').process_mode = PROCESS_MODE_INHERIT
	mask.player.speed_modifier = 1.0
	mask.player.DECELERATION_DEFAULT = old_decel_default
	mask.player.DECELERATION_SLIDE = old_decel_slide
	mask.player.get_node("Neck/Camera3D").fov = old_fov
	world_environment.environment.fog_enabled = true


func Update(delta: float):
	get_parent().mask_update(delta, self)
