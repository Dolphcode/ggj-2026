extends BaseEnemyState

@export_category("Transition Config")
@export var exit_state: BaseEnemyState
@export var anim_player: AnimationPlayer

@export_category("Hurtbox Config")
@export var melee_hurtbox: Area3D

var attack_done: bool = false

func enter() -> void:
	anim_player.play("Attack")
	attack_done = false


func exit() -> void:
	controller.global_cd_timer = controller.global_cd


func update(delta: float) -> void:
	if attack_done:
		controller.transition_state = exit_state


## This function is called every physics frame
func physics_update(delta: float) -> void:
	var original_y = controller.velocity.y
	controller.velocity = Vector3.ZERO
	controller.velocity.y = original_y
	controller.velocity += controller.get_gravity() * delta


func attack_up():
	melee_hurtbox.get_node("CollisionShape3D").disabled = false


func attack_down():
	melee_hurtbox.get_node("CollisionShape3D").disabled = true


func end_attack():
	attack_done = true
