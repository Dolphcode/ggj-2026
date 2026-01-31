extends CharacterBody3D
class_name BaseEnemy

# EXPORT
@export_category("Base Enemy Config")
@export var base_speed: float = 2.0
@export var attack_range_sq: float = 100.0
@export var turn_speed: float = 2.0
@export var global_cd: float = 1.0
@export var max_health: float = 100.0

@export_category("State Config")
@export var starting_state: BaseEnemyState

@export var target: Node3D

# ONREADY
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

# STATE
var current_state: BaseEnemyState
var transition_state: BaseEnemyState
var global_cd_timer: float = 0.0
var current_health: float = 0.0

func _ready():
	current_health = max_health
	
	current_state = starting_state
	current_state.enter()
	transition_state = current_state


func _process(delta: float) -> void:
	# Decrement global cooldown
	if global_cd_timer > 0.0:
		global_cd_timer -= delta
	
	# Check state transition
	if current_state != transition_state:
		current_state.exit()
		transition_state.enter()
		current_state = transition_state
	
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Execute physics update
	current_state.physics_update(delta)
	
	move_and_slide()


func damage(amount: float) -> void:
	current_health = clampf(current_health - amount, 0.0, max_health)
	
	if current_health <= 0:
		queue_free()
