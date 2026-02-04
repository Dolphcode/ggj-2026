extends BaseEnemyState

@export_category("Transition Config")
@export var exit_state: BaseEnemyState
@export var anim_player: AnimationPlayer

@export_category("Hurtbox Config")
@export var melee_hurtbox: Area3D

var start_jump: bool = false
var finish_jump: bool = false

func enter() -> void:
	get_parent().get_node("Ribbit").play()
	start_jump = true
	finish_jump = false
	melee_hurtbox.get_node("CollisionShape3D").disabled = false


func exit() -> void:
	melee_hurtbox.get_node("CollisionShape3D").disabled = true
	controller.global_cd_timer = controller.global_cd


func update(_delta: float) -> void:
	if not finish_jump:
		return
	controller.transition_state = exit_state


## This function is called every physics frame
func physics_update(delta: float) -> void:
	if start_jump:
		controller.velocity.y = 15
		anim_player.play("Jump")
		start_jump = false
	else:
		var original_y = controller.velocity.y
		controller.velocity = Vector3.FORWARD.rotated(Vector3.UP, controller.rotation.y) * 5 * delta * controller.base_speed
		controller.velocity.y = original_y
		controller.velocity += controller.get_gravity() * delta * 5
		if controller.is_on_floor():
			anim_player.play_backwards("Jump")
			finish_jump = true
	pass
