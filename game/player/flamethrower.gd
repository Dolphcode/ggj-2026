extends Node3D

var projectile = preload('res://projectile.tscn')
@export var player_cam : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("attack"):
		var new_instance = projectile.instantiate()
		new_instance.transform.origin = Vector3(get_parent().global_position.x + randf()/2, get_parent().global_position.y + randf()/2, get_parent().global_position.z + randf()/2)
		var center = player_cam.get_viewport().get_size() / 2
		var ray_origin = player_cam.project_ray_origin(center)
		var ray_direction = player_cam.project_ray_normal(center)

		new_instance.direction = Vector3(ray_direction.x + randf()/2, ray_direction.y + randf()/2, ray_direction.z + randf()/2)
		get_tree().root.get_node('Node3D').add_child(new_instance)
			
#func _physics_process(delta):
	#if get_tree().root.get_node('Node3D').has_node("Projectile"):
		
