extends Area3D
class_name EnemyHurtbox

@export var base_damage: float = 10.0

func get_damage() -> float:
	return base_damage
