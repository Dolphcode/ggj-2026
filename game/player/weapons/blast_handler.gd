extends Node3D
class_name ShotgunBlastHandler

@export_category("Shotgun Regular")
@export var light_sr: OmniLight3D
@export var part_sr: GPUParticles3D
@export var shotgun: Node3D

@export_category("Frozen Shotgun")
@export var light_si: OmniLight3D
@export var part_si: GPUParticles3D
@export var icegun: Node3D

@export_category("Radar Shotgun")
@export var light_rs: OmniLight3D
@export var part_rs: GPUParticles3D

@export_category("State Machine")
@export var state_machine: MaskHandler

var light_sr_tween: Tween
var shotgun_sr_tween: Tween
var shotgun_sr_back_pos: Vector3

var light_si_tween: Tween
var shotgun_si_tween: Tween
var shotgun_si_back_pos: Vector3

var light_rs_tween: Tween

func fire():
	if state_machine.current_state is radar_mask:
		light_rs_tween.kill()
		light_rs_tween = get_tree().create_tween()
		light_rs.light_energy = 5.0
		light_rs_tween.tween_property(light_rs, "light_energy", 0.0, 0.5)
		part_rs.emitting = false
		part_rs.emitting = true
	elif state_machine.current_state is ice_mask:
		light_si_tween.kill()
		light_si_tween = get_tree().create_tween()
		light_si.light_energy = 5.0
		light_si_tween.tween_property(light_si, "light_energy", 0.0, 0.5)
		part_si.emitting = false
		part_si.emitting = true
		shotgun_si_tween.kill()
		shotgun_si_tween = get_tree().create_tween()
		icegun.position = shotgun_si_back_pos
		shotgun_si_tween.tween_property(icegun, "position",  Vector3(0.0, 0.0, -0.7) + icegun.position, 0.5)
		
	else:
		light_sr_tween.kill()
		light_sr_tween = get_tree().create_tween()
		light_sr.light_energy = 5.0
		light_sr_tween.tween_property(light_sr, "light_energy", 0.0, 0.5)
		part_sr.emitting = false
		part_sr.emitting = true
		shotgun_sr_tween.kill()
		shotgun_sr_tween = get_tree().create_tween()
		shotgun.position = shotgun_sr_back_pos
		shotgun_sr_tween.tween_property(shotgun, "position",  Vector3(0.0, 0.0, -0.7) + shotgun.position, 0.5)
		
	


# Called when the node enters the scene tree for the first time.
func _ready():
	light_sr_tween = get_tree().create_tween()
	shotgun_sr_tween = get_tree().create_tween()
	shotgun_sr_back_pos = Vector3(0.0, 0.0, 0.7) + shotgun.position
	
	light_rs_tween = get_tree().create_tween()
	
	light_si_tween = get_tree().create_tween()
	shotgun_si_tween = get_tree().create_tween()
	shotgun_si_back_pos = Vector3(0.0, 0.0, 0.7) + icegun.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
