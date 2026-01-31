extends Camera3D

@export_category("Gun Config")
@export var ray_range = 10
@export var spread_factor: float = 5.0
@export var amount: int = 5

func _input(event):
	if event.is_action_pressed("attack"):
		get_camera_collision()
		
func get_camera_collision():
	var center = get_viewport().get_size() / 2
	
	var ray_origin = project_ray_origin(center)
	for i in range(amount):
		var shot_dir = project_ray_normal(center).rotated(Vector3.RIGHT, randf() * deg_to_rad(spread_factor))
		shot_dir = shot_dir.rotated(Vector3.UP, randf() * deg_to_rad(spread_factor))
		var ray_end = ray_origin + shot_dir * ray_range
		
		
		var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, 4)
		new_intersection.collide_with_areas = true
		var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
		
		if not intersection.is_empty():
			print(intersection.collider.name)
		else:
			print("nothing")	
	
