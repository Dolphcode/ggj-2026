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
	if body is Player:
		var mask_queue: MaskHandler = body.get_node("Mask/StateMachine")
		if not mask_queue.is_queue_full():
			mask_queue.mask_queue.append(type)
			queue_free()
