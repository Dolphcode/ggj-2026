class_name IdlePlayerState
extends PlayerState
 
func update(delta) -> void:
	if global.player.velocity.length() > 0 and global.player.is_on_floor():
		transition.emit("WalkingPlayerState")
