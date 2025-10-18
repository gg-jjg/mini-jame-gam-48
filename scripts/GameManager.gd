extends Node

var gravity = "V"

func set_gravity(val):
	print("Setting the gravity: ", val)
	gravity = val

func get_gravity():
	return gravity
