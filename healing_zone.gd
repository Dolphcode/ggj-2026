extends Node3D


# Called when the node enters the scene tree for the first time.
var enemies_in_radius = []
@export var healing = 0.1


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for enemy in enemies_in_radius:
		if enemy is BaseEnemy:
			print(enemy)
			enemy.current_health += healing
#		heal the enemy

func _on_area_3d_body_entered(body):
	print("enter")
	enemies_in_radius.append(body)


func _on_area_3d_body_exited(body):
	print('exit')
	enemies_in_radius.erase(body)
