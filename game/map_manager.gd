extends Node

@export var difficulty_factor = 1.0
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

enum MaskType {FIRE, ICE, RADAR, RAGE}
enum EnemyType {LIGHT, HEAVY, LUNGE, DASH, FLYLUNGE, FLYSNIPE}
enum RoomType{TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, CENTER}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MaskSpawnTimer.wait_time = mask_spawn_time
	%EnemySpawnTimer.wait_time = enemy_spawn_time
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_spawn_timer_timeout() -> void:
	var current_room: Node3D = rooms.pick_random()
	while (%Player.current_room == current_room):
		current_room = rooms.pick_random()
		print(current_room)
	
	var children_in_group = []
	for node in get_tree().get_nodes_in_group("spawns"):
		if node.get_parent() == current_room:
			children_in_group.append(node)
	
	var spawn_pos = children_in_group.pick_random().global_position
	var new_enemy: BaseEnemy = enemies.pick_random().instantiate()
	new_enemy.position = spawn_pos
	new_enemy.target = %Player
	print("spawned enemy ", new_enemy.name, " at ", spawn_pos)
	call_deferred("add_child", new_enemy)
	pass # Replace with function body.

func _on_mask_spawn_timer_timeout() -> void:
	spawn_masks()
	pass # Replace with function body.
	
func spawn_masks():
	var count = 0
	var mask_spawns = get_tree().get_nodes_in_group("mask_spawns")
	mask_spawns.shuffle()
	var new_mask
	for spawn in mask_spawns:
		pass
		#new_mask = masks[count].instantiate()
		#new_mask.position = spawn.global_position
		#print("spawned ", masks[count], " at ", spawn.get_parent().name)
		#call_deferred("add_child", new_mask)
		#count += count
	pass
