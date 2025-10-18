extends Node

var gravity = 0

func set_gravity(val):
	print("Setting the gravity: ", val)
	gravity = val

func get_gravity():
	return gravity
