extends Camera

onready var Player = get_node("../Main/Player")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-event.relative.x * mouse_sensitivity)
	pass

func _process(delta):
	
	pass
