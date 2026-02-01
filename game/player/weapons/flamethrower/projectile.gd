extends Node3D


# Called when the node enters the scene tree for the first time.
@export_category("Movement Config")
@export var projectile_speed = 30.0
var direction = Vector3.ZERO
@export var projectile_distance = .3

@export_category("Damage Config")
@export var projectile_damage: float = 10.0

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if projectile_distance > 0:
		projectile_distance -= delta
	else:
		queue_free()

func _physics_process(delta):
	global_position += projectile_speed * direction * delta


func _on_area_3d_area_entered(area):
	if area is EnemyHitbox:
		area.damage(projectile_damage, true, false)
