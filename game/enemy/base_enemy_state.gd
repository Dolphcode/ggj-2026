extends Node
## 
class_name BaseEnemyState

## The state controller, being the parent Node
@onready var controller: BaseEnemy = get_parent()

## This function is called when this state is entered after a previous
## state has been exited or on the first frame that the enemy is ready
## to begin acting
func enter() -> void:
	pass


## This function is called when this state is exited before the next state
## is entered.
func exit() -> void:
	pass


## This function is called every frame
func update(_delta: float) -> void:
	pass


## This function is called every physics frame
func physics_update(_delta: float) -> void:
	pass
