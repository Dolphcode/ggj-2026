extends Node3D

@export_category("Fire Config")
var projectile = preload('res://game/player/weapons/flamethrower/projectile.tscn')
@export var facing_obj : Node3D
@export var fire_point: Node3D

@export_category("References")
@export var health_manager: HealthManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("attack"):
		if get_node("flame").playing == false:
			get_node("flame").play()
		# Create a projectile
		var new_instance = projectile.instantiate()
		new_instance.transform.origin = Vector3(get_parent().global_position.x + randf()/2, get_parent().global_position.y + randf()/2, get_parent().global_position.z + randf()/2)
		
		# Forward direction based on neck
		var direction = -facing_obj.global_transform.basis.z
		
		# Set the direction of the flamethrower
		new_instance.direction = Vector3(direction.x + randf()/2, direction.y + randf()/2, direction.z + randf()/2)
		new_instance.position = fire_point.global_position
		
		# Apply damage modifier to projectile
		var modifier = lerp(health_manager.damage_modifier_min, 
			health_manager.damage_modifier_max, 
			1.0 - health_manager.current_health / health_manager.max_health)
		new_instance.projectile_damage *= modifier
		
		# Add to the scene
		get_parent().get_parent().add_child(new_instance)
	elif get_node("flame").playing == true:
		get_node("flame").stop()
		
			
#func _physics_process(delta):
	#if get_tree().root.get_node('Node3D').has_node("Projectile"):
		
