extends Node3D

@export var player_cam: Camera3D

@export_category("Gun Config")
@export var ray_range = 10
@export var spread_factor: float = 5.0
@export var amount: int = 5
@export var damage: float = 2.0
@export var is_ice: bool = false
@export var reload_cd: float = 0.4

@export_category("Fire Point Config")
@export var facing_obj : Node3D
@export var fire_point: Node3D

@onready var health_manager: HealthManager = get_parent().get_node("HealthManager")
@onready var shoot_sfx: AudioStreamPlayer = get_parent().get_node("Shoot")
@onready var reload_sfx: AudioStreamPlayer = get_parent().get_node("Reload")

var reload_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reload_time <= 0.0:
		if Input.is_action_just_pressed("attack"):
			reload_time = reload_cd
			shoot_sfx.play()
			
			var ray_origin = fire_point.global_position
			var shot_dir = -facing_obj.global_transform.basis.z
			for i in range(amount):
				# Rotate the direction
				var rotated_shot_dir = shot_dir.rotated(Vector3.UP, randf() * deg_to_rad(spread_factor))
				
				# Compute the ray end
				var ray_end = ray_origin + rotated_shot_dir * ray_range
				
				# Raycast
				var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 4)
				new_intersection.collide_with_areas = true
				var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
				
				# See if intersection
				if not intersection.is_empty():
					var hitbox: Node3D = intersection.collider
					if hitbox is EnemyHitbox:
						# Apply damage modifier to projectile
						var modifier = lerp(health_manager.damage_modifier_min, 
						health_manager.damage_modifier_max, 
						1.0 - health_manager.current_health / health_manager.max_health)	
						
						_spawn_impact_marker(intersection.position, intersection.normal, hitbox, is_ice)
						hitbox.damage(damage * modifier, false, is_ice)
	else:
		reload_time -= delta
		if reload_time <= 0.0:
			reload_sfx.play()

@onready var blood = preload("res://game/particles/blood_particles.tscn")
@onready var crit_blood = preload("res://game/particles/crit_blood_particles.tscn")
@onready var ice_part = preload("res://game/particles/ice_particles.tscn")

func _spawn_impact_marker(position: Vector3, normal: Vector3, hitbox: EnemyHitbox, is_ice: bool) -> void:
	var particles: OneShotParticles = null
	
	if is_ice:
		particles = ice_part.instantiate()
	elif hitbox.damage_modifier > 1.0:
		particles = crit_blood.instantiate()
	else:
		particles = blood.instantiate()
	
	particles.process_material.direction = normal
	particles.position = position
	get_parent().get_parent().call_deferred("add_child", particles)
	'''
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	new_parent.add_child(marker)
	marker.global_position = position
	
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)
	'''
