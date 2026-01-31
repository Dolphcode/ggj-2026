extends Node3D

@export var player_cam: Camera3D

@export_category("Gun Config")
@export var ray_range = 10
@export var spread_factor: float = 5.0
@export var amount: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var center = player_cam.get_viewport().get_size() / 2
	
		var ray_origin = player_cam.project_ray_origin(center)
		for i in range(amount):
			var shot_dir = player_cam.project_ray_normal(center).rotated(Vector3.RIGHT, randf() * deg_to_rad(spread_factor))
			shot_dir = shot_dir.rotated(Vector3.UP, randf() * deg_to_rad(spread_factor))
			var ray_end = ray_origin + shot_dir * ray_range
			
			var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 4)
			new_intersection.collide_with_areas = true
			var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
			
			if not intersection.is_empty():
				print(intersection.collider.name)
				var hitbox: Node3D = intersection.collider
				if hitbox.has_method("damage"):
					hitbox.damage(2, false, false)
