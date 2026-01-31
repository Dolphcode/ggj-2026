extends Node3D
class_name HealthManager

# Export
@export_category("Hit Config")
@export var immunity_time: float = 0.2

@export_category("Health Config")
@export var max_health: float = 100.0

# State
var immunity_active_time: float = 0.0
var current_health: float

# On Ready
@onready var hud = get_parent().get_node("HUD")

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Reduce timer
	if immunity_active_time >= 0.0:
		immunity_active_time -= delta
	
	# Update healthbar
	var relative_health: float = current_health / max_health
	hud.get_node("HSlider").value = relative_health


func hit():
	if immunity_active_time >= 0.0:
		return
	print("I was hit")
		
	current_health -= 10
	immunity_active_time = immunity_time

func _on_standing_hitbox_area_entered(area):
	print("test")
	hit()
