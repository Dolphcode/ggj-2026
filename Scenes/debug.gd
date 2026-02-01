extends PanelContainer

@onready var property_container = %VBoxContainer

#var property
var frames_per_second : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	global.debug = self
	

func _input(event):
	# Toggle debug
	if event.is_action_pressed("debug"):
		visible = !visible

func _process(delta):
	if visible: 
		#frames_per_second = "%.2f" % (1.0/delta)
		#property.text = property.name + ": " + frames_per_second
		#global.debug.add_property("FPS", frames_per_second, 2)
		pass
		
func add_property(title: String, value, order):
	var target 
	target = property_container.find_child(title, true, false)
	if !target: 
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
