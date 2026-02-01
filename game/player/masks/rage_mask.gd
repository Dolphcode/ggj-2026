extends State
class_name rage_mask

#Enables berserk mode
#allows you to one shot enemies for a short time
#sends you into a blind rage
#significantly impairs vision
#medium length

@onready var mask = get_parent().get_parent()
@onready var cam = mask.player.get_node("Neck/Camera3D")
@onready var world_environment:WorldEnvironment = mask.player.get_node("../WorldEnvironment")
@onready var shader:MeshInstance3D = cam.get_node("shader")
@onready var trauma = 1.0
@onready var max_offset = Vector3(0.2, 0.2, 0.2)
@onready var amount = pow(trauma, 2)

@export var mask_time = 20
@export var speed_multiplier = 2.0
@export var damage_multiplier = 3.0
#Called on equpping rage mask
func Enter():
	get_parent().mask_time = mask_time #medium
	get_parent().mask_timer.max_value = mask_time
	get_parent().mask_timer.visible = true
	AudioManager.get_node("RageEquip").play()
	AudioManager.get_node("Music").pitch_scale = 2.0
	mask.player.speed_modifier = speed_multiplier #currently increases speed [may remove this]
	mask.player.get_node("Shotgun").damage *= damage_multiplier
	world_environment.environment.fog_light_color = Color(0.227, 0.0, 0.016)
	shader.mesh.surface_get_material(0).set_shader_parameter("gamma", Vector2(0.125, 13.0))
	#	change camera fov and color



	#gun_type = 'normal' #note that this gun will be mega buffed
	
#Called on rage mask timeout/new mask equipped
func Exit():
	mask.player.speed_modifier = 1.0
	AudioManager.get_node("Music").pitch_scale = 1.0
	mask.player.get_node("Shotgun").damage /= damage_multiplier
	cam.fov = 75.0
	world_environment.environment.fog_light_color = Color(0.227, 0.184, 0.016)
	shader.mesh.surface_get_material(0).set_shader_parameter("gamma", Vector2(0.125, 11.0))
	
func Update(delta: float):
	get_parent().mask_update(delta, self)
		
func Physics_Update(_delta:float):
		# Randomize position slightly for violent effect
	cam.position.x = randf_range(-max_offset.x, max_offset.x) * amount
	cam.position.y = randf_range(-max_offset.y, max_offset.y) * amount
	# Add FOV kick
	cam.fov = 70 + (15 * amount)
