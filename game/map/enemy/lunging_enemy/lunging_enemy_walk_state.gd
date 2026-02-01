extends BaseEnemyState

@export_category("Transition Config")
@export var exit_state: BaseEnemyState
@export var transition_cd: float = 0.2
@export var anim_player: AnimationPlayer

var curr_transition_cd: float = 0.0

func enter() -> void:
	curr_transition_cd = transition_cd
	anim_player.play("Walk")
	anim_player.get_animation("Walk").loop_mode = Animation.LOOP_LINEAR


func exit() -> void:
	pass


func update(delta: float) -> void:
	#if curr_transition_cd > 0.0:
	#	curr_transition_cd -= delta
	#	return
		
	if (controller.position - controller.target.position).length_squared() < controller.attack_range_sq:
		controller.transition_state = exit_state


## This function is called every physics frame
func physics_update(delta: float) -> void:
	# Path query
	controller.nav_agent.target_position = controller.target.position
	
	# Get the next position
	var target_pos: Vector3 = controller.nav_agent.get_next_path_position()
	var target_dir: Vector2 = Vector2(controller.position.z - target_pos.z, controller.position.x - target_pos.x)
	
	controller.rotation.y = rotate_toward(controller.rotation.y, target_dir.angle(), controller.turn_speed * delta)
	
	# Convert to motion
	var original_y = controller.velocity.y
	controller.velocity = Vector3.FORWARD.rotated(Vector3.UP, controller.rotation.y) * delta * controller.base_speed
	controller.velocity.y = original_y
	controller.velocity += controller.get_gravity() * delta
	
