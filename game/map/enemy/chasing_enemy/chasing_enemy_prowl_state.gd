extends BaseEnemyState

@export_category("Transition Config")
@export var exit_state: BaseEnemyState
@export var transition_cd: float = 0.2
@export var anim_player: AnimationPlayer

@export_category("Attack Config")
@export var attack_state: BaseEnemyState

var curr_transition_cd: float = 0.0
var attack_transition_cd: float = 0.0

func enter() -> void:
	curr_transition_cd = transition_cd
	anim_player.play("Idle")


func exit() -> void:
	pass


func update(delta: float) -> void:
	if controller.global_cd_timer <= 0.0:
		controller.transition_state = attack_state
	
	if (controller.position - controller.target.position).length_squared() >= controller.attack_range_sq:
		if curr_transition_cd > 0.0:
			curr_transition_cd -= delta
		else:
			controller.transition_state = exit_state


## This function is called every physics frame
func physics_update(delta: float) -> void:
	# Get the next position
	var target_pos: Vector3 = controller.target.position
	var target_dir: Vector2 = Vector2(controller.position.z - target_pos.z, controller.position.x - target_pos.x)
	
	controller.rotation.y = rotate_toward(controller.rotation.y, target_dir.angle(), controller.turn_speed * delta)
	
	var original_y = controller.velocity.y
	controller.velocity = Vector3.ZERO
	controller.velocity.y = original_y
	controller.velocity += controller.get_gravity() * delta
