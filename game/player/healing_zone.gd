extends Node3D


# Called when the node enters the scene tree for the first time.
var enemies_in_radius = []
@export var healing = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for enemy in enemies_in_radius:
		if enemy is BaseEnemy:
			#print(enemy)
			enemy.current_health += healing

func _on_healing_area_3d_body_entered(body):
	if body is BaseEnemy:
		#print("enter")
		body.start_heal_effect()
		enemies_in_radius.append(body)


func _on_healing_area_3d_body_exited(body):
	if body is BaseEnemy:
		#print('exit')
		body.stop_heal_effect()
		enemies_in_radius.erase(body)
