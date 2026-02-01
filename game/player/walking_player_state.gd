class_name WalkingPlayerState
extends PlayerState

func update(delta) -> void:
	if global.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")
