extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_uses = 3
var uses

var fadetime = 5
var fade_countdown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	uses = max_uses
	pass # Replace with function body.

func use():
	if uses > 0:
		uses -= 1
		$Particles.emitting = true
		return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if fade_countdown > 0:
		fade_countdown -= delta
	pass
