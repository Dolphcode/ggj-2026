extends CharacterBody3D
class_name BaseEnemy


const SPEED = 2.0
const JUMP_VELOCITY = -400.0

@export var target: Node3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var target_pos: Vector3

func _ready():
	nav_agent.target_position = target.global_position
	

func _physics_process(delta: float) -> void:
	
	nav_agent.target_position = target.global_position
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	target_pos = nav_agent.get_next_path_position()
	position = position.move_toward(target_pos, delta * SPEED)

	move_and_slide()
