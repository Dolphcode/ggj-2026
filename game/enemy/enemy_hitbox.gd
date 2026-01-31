extends Area3D
class_name EnemyHitbox

@export_category("Hitbox Config")
@export var damage_modifier: float = 1.0
@export var fire_modifier: float = 1.0
@export var controller: BaseEnemy

func damage(amount: float, is_fire: bool, is_ice: bool) -> void:
	if not is_fire:
		controller.damage(amount * damage_modifier)
	else:
		controller.damage(amount * fire_modifier)
	
