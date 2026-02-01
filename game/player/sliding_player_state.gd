class_name SlidingPlayerState
extends PlayerState

func update(delta) -> void:
	if global.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")
		
func finish():
	transition.emit("IdlePlayerState")
