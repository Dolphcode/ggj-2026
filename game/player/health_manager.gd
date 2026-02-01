extends Node3D
class_name HealthManager

# Export
@export_category("Hit Config")
@export var immunity_time: float = 0.2

@export_category("Health Config")
@export var max_health: float = 100.0

@export_category("Damage Modifier")
@export var damage_modifier_min: float = 1.0
@export var damage_modifier_max: float = 2.0

# State
var immunity_active_time: float = 0.0
var current_health: float

# On Ready
@onready var hud_slider = get_parent().get_node("HUD/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/HSlider")
@onready var hud_text = get_parent().get_node("HUD/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/Label")

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
	hud_slider.value = relative_health
	hud_text.text = str(roundi(clampf(relative_health * 100, 0, 100))) + "%"


func hit(damage: float) -> void:
	if immunity_active_time >= 0.0:
		return
	
	var damage_sounds = ["TakingDamage", "TakingDamage2", "TakingDamage3"]
	get_parent().get_node(damage_sounds.pick_random()).play()
		
	current_health = clampf(current_health - damage, 0.0, max_health)
	
	immunity_active_time = immunity_time
	if (current_health <= 0):
		hud_slider.value = 0
		get_node("..").die.emit()

func _on_standing_hitbox_area_entered(area):
	if area is EnemyHurtbox:
		hit(area.get_damage())
