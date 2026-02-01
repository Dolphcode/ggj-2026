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
	
	controller.nav_agent.target_position = controller.target.position


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
	# Only requery under distance constraints
	var target_pos_change = (controller.target.position - controller.nav_agent.target_position).length_squared()
	var distance_to_target = (controller.position - controller.target.position).length_squared()
	if (distance_to_target < 10 * 10 and target_pos_change < 3 * 3) or (distance_to_target < 50 * 50 and target_pos_change < 20 * 20) or (distance_to_target < 100 * 100 and target_pos_change < 40 * 40) or (target_pos_change < 100 * 100):
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
	
