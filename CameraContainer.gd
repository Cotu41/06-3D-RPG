extends Spatial

onready var Player = get_node("/root/Main/Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var mouse_sensitivity = 0.002

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin = Player.global_transform.origin
	pass
