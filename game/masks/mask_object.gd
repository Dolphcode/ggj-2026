extends Node3D

@export var type = "fire_mask"
signal mask_pick_up(Node3D)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	mask_pick_up.emit(type)
	queue_free()
	pass # Replace with function body.
