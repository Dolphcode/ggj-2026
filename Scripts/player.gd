extends CharacterBody3D
class_name Player

@export var SPEED = 10.0
@export var JUMP_VELOCITY = 9.0
@export var SENSITIVITY = 0.005
@export var GRAVITY_MODIFIER = 2.0
@export var ACCELERATION_DEFAULT = 0.1
@export var DECELERATION_DEFAULT = 1.0
@export var ACCELERATION = ACCELERATION_DEFAULT
@export var DECELERATION = DECELERATION_DEFAULT

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

var speed_modifier := 1.0
var player_velocity


@onready var slide_check = $SlideCheck

func _ready(): 
	global.player = self

func _unhandled_input(event: InputEvent) -> void:
	# ANY BUTTON : Mouse cursor disappears
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# ESC : Mouse cursor reappears
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# 0.01 is just a sensitivity, will export later as sensitivity
			neck.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	global.debug.add_property("MovementSpeed", SPEED, 1)
	global.debug.add_property("Acceleration", ACCELERATION, 1)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MODIFIER * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	# Direction is based on the neck
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED * speed_modifier, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * SPEED * speed_modifier, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)
		
	if Input.is_action_just_pressed("attack"): 
		print("attack")
		
	global.debug.add_property("Velocity", velocity, 2)

	move_and_slide()
