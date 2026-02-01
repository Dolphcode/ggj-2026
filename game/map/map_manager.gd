extends Node

@export var difficulty_factor = 1.0
@export var enemy_cap = 50
@export var enemy_spawn_time = 15.0
@export var mask_spawn_time = 15.0

@export_category("Mask Types")
@export var fire_mask_obj:PackedScene #whatever class the mask is
@export var ice_mask_obj:PackedScene #^
@export var radar_mask_obj:PackedScene #^
@export var rage_mask_obj:PackedScene #^

@export_category("Enemy Types")
@export var light_enemy:PackedScene
@export var heavy_enemy:PackedScene
@export var lunge_enemy:PackedScene
@export var dash_enemy:PackedScene
@export var flylunge_enemy:PackedScene
@export var flysnipe_enemy:PackedScene

@export_category("Rooms")
@export var top_left:Node3D
@export var top_right:Node3D
@export var bottom_left:Node3D
@export var bottom_right:Node3D
@export var center:Node3D

@onready var rooms = [top_left, top_right, bottom_left, bottom_right, center]
@onready var enemies = [light_enemy, heavy_enemy, lunge_enemy, dash_enemy, flylunge_enemy, flysnipe_enemy]
@onready var masks = [fire_mask_obj, ice_mask_obj, radar_mask_obj, rage_mask_obj]
@onready var mask_state = %Player.get_node("Mask/State Machine")

var score = 0
var score_modifier = 100
var paused = false
@onready var ui:CanvasLayer = %Player.get_node("HUD")
@onready var end_screen:Control = ui.get_node("UserInterface/EndScreen")

#enum MaskType {FIRE, ICE, RADAR, RAGE}
#enum EnemyType {LIGHT, HEAVY, LUNGE, DASH, FLYLUNGE, FLYSNIPE}
#enum RoomType{TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, CENTER}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MaskSpawnTimer.wait_time = mask_spawn_time
	%EnemySpawnTimer.wait_time = enemy_spawn_time
	end_screen.visible = false
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not paused:
		paused = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		end_screen.visible = true
		end_screen.get_node("LoseLabel").visible = false
		end_screen.get_node("FinalLabel").text = "Current Score: " + str(score)
	elif Input.is_action_just_pressed("pause") and paused:
		paused = false
		get_tree().paused = false
		end_screen.visible = false
		end_screen.get_node("LoseLabel").visible = true

func _on_enemy_spawn_timer_timeout() -> void:
	if (enemy_cap < get_tree().get_nodes_in_group("enemies").size()):
		#print("capped")
		return
	var current_room: Node3D = rooms.pick_random()
	while (%Player.current_room == current_room):
		current_room = rooms.pick_random()
	
	var children_in_group = []
	for node in get_tree().get_nodes_in_group("spawns"):
		if node.get_parent() == current_room:
			children_in_group.append(node)
	
	var spawn_pos = children_in_group.pick_random().global_position
	#= enemies.pick_random().instantiate()
	var new_enemy: BaseEnemy
	var chance = randi() % 100
	if chance > 54:
		new_enemy = enemies[0].instantiate() #light enemy
	elif chance > 24:
		new_enemy = enemies[2].instantiate() #lunging enemy
	elif chance > -1:
		new_enemy = enemies[1].instantiate() #heavy enemy
	new_enemy.position = spawn_pos
	new_enemy.target = %Player
	new_enemy.add_to_group("enemies")
	new_enemy.die.connect(on_enemy_death)
	#print("spawned enemy ", new_enemy.name, " at ", spawn_pos)
	get_parent().call_deferred("add_child", new_enemy)
	pass # Replace with function body.

func _on_mask_spawn_timer_timeout() -> void:
	spawn_masks()
	pass # Replace with function body.
	
func spawn_masks():
	var old_masks = get_tree().get_nodes_in_group("mask_objs")
	for mask in old_masks:
		mask.queue_free()
	var count = 0
	var mask_spawns = get_tree().get_nodes_in_group("mask_spawns")
	mask_spawns.shuffle()
	var new_mask
	for spawn in mask_spawns:
		new_mask = masks[count].instantiate()
		new_mask.position = spawn.global_position
		#print("spawned ", new_mask.type, " at ", spawn.get_parent().name)
		call_deferred("add_child", new_mask)
		count += 1
	pass
	
func on_enemy_death():
	score += 1 * score_modifier
	ui.get_node("VBoxContainer/ScoreLabel").text = "Score: " + str(score)
	
func on_player_death():
	get_tree().paused = true
	var death_sounds = ['PlayerDeath', 'PlayerDeath2', 'PlayerDeath3']
	AudioManager.get_node(death_sounds.pick_random()).play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_screen.visible = true
	end_screen.get_node("VBoxContainer/FinalLabel").text = "Final Score: " + str(score)


func start_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	#end_screen.visible = false
