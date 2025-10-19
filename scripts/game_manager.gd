extends Node

var gesture = "V"
var gesture_map = {
	"Λ": Vector2.UP,
	"V": Vector2.DOWN,
	"<": Vector2.LEFT,
	">": Vector2.RIGHT
}

var selected_object

func set_gesture(val):
	gesture = val
	#print("Setting the gesture: ", gesture)
