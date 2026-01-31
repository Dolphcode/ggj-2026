extends BaseEnemyState

@export_category("Transition Config")
@export var exit_state: BaseEnemyState
@export var transition_cd: float = 0.2

@export_category("Hurtbox Config")
@export var melee_hurtbox: Area3D

var curr_transition_cd: float = 0.0

func enter() -> void:
	curr_transition_cd = transition_cd
	melee_hurtbox.get_node("CollisionShape3D").disabled = false


func exit() -> void:
	melee_hurtbox.get_node("CollisionShape3D").disabled = true
	controller.global_cd_timer = controller.global_cd


func update(delta: float) -> void:
	if curr_transition_cd > 0.0:
		curr_transition_cd -= delta
		return
	
	controller.transition_state = exit_state


## This function is called every physics frame
func physics_update(delta: float) -> void:
	pass
