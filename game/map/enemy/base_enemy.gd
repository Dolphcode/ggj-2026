extends CharacterBody3D
class_name BaseEnemy

# EXPORT
@export_category("Base Enemy Config")
@export var base_speed: float = 2.0
@export var attack_range_sq: float = 100.0
@export var turn_speed: float = 2.0
@export var global_cd: float = 1.0
@export var max_health: float = 100.0
@export var freeze_time: float = 2.0

@export_category("State Config")
@export var starting_state: BaseEnemyState

@export var target: Node3D
@export var mesh: MeshInstance3D
@export var anim_player: AnimationPlayer

@export var enemy_death_sound: String

var is_frozen: bool = false
var frozen_time_left: float = 0.0

# ONREADY
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

# SIGNAL
signal die()

# STATE
var current_state: BaseEnemyState
var transition_state: BaseEnemyState
var global_cd_timer: float = 0.0
var current_health: float = 0.0
var dead = false

func _ready():
	current_health = max_health
	
	current_state = starting_state
	current_state.enter()
	transition_state = current_state


func _process(delta: float) -> void:
	if not is_frozen:
		# Decrement global cooldown
		if global_cd_timer > 0.0:
			global_cd_timer -= delta
		
		# Check state transition
		if current_state != transition_state:
			current_state.exit()
			transition_state.enter()
			current_state = transition_state
		
		current_state.update(delta)
	else:
		# Unfreeze logic
		
		frozen_time_left -= delta
		if frozen_time_left <= 0.0:
			is_frozen = false
			if mesh != null:
				mesh.set_instance_shader_parameter("is_frozen", false)
				
			# Just raw reset 
			current_state = starting_state
			current_state.enter()
			transition_state = current_state


func _physics_process(delta: float) -> void:
	if not is_frozen:
		# Execute physics update
		current_state.physics_update(delta)
	else:
		var original_y = velocity.y
		velocity = Vector3.ZERO
		velocity.y = original_y
		velocity += get_gravity() * delta
	move_and_slide()


func start_heal_effect() -> void:
	if mesh != null:
			mesh.set_instance_shader_parameter("is_healing", true)


func stop_heal_effect() -> void:
	if mesh != null:
			mesh.set_instance_shader_parameter("is_healing", false)


func freeze() -> void:
	if is_frozen:
		anim_player.play("Idle")
		frozen_time_left = freeze_time
	else:
		is_frozen = true
		frozen_time_left = freeze_time
		if mesh != null:
			mesh.set_instance_shader_parameter("is_frozen", true) 


func damage(amount: float, is_freeze: bool) -> void:
	#print("Amount: " + str(amount))
	current_health = clampf(current_health - amount, 0.0, max_health)
	
	if is_freeze:
		freeze()

	if current_health <= 0:
		if not dead:
			AudioManager.get_node(enemy_death_sound).global_position = global_position
			AudioManager.get_node(enemy_death_sound).play()
			dead = true
			die.emit()
			queue_free()
