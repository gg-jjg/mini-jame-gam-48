extends Node2D

var drawing_points = []
var last_point = Vector2.ZERO
const DISTANCE_THRESHOLD = 100.0
@onready var line = $Line2D

func _input(event):
	if Input.is_action_just_pressed("write"):
		drawing_points.clear() # Clear previous points on new write
		print('Write: start')
		last_point = event.position
		drawing_points.append(last_point)
	
	elif event is InputEventMouseMotion and Input.is_action_pressed("write"):
		# Track mouse movement while writing
		var distance = last_point.distance_to(event.position)

		if distance > DISTANCE_THRESHOLD:
			print("  Captured point")
			last_point = event.position
			drawing_points.append(last_point)
	
	elif Input.is_action_just_released("write"):
		
		print('Write: end')
		drawing_points.append(event.position)
		
		#debug_print_points()
		draw_three_points(drawing_points)

func draw_three_points(points_array):
	#Draws a line connecting the start point, the midpoint, and the end point of the given points array.
	
	var mid_point = get_middle_point(points_array)
	
	line.clear_points() # Clear previous line on new write
	line.add_point(points_array[0])
	line.add_point(mid_point)
	line.add_point(points_array[len(points_array) - 1])

func get_middle_point(points_array):
	var length = len(points_array)
	var mid = length / 2
	var middle_point = Vector2.ZERO

	if length % 2 == 0:
		# Even number of points: interpolate between the two middle points
		var point_a = points_array[mid - 1]
		var point_b = points_array[mid]
		middle_point = point_a.lerp(point_b, 0.5)
	else:
		# Odd number of points: return the middle point directly
		middle_point =  points_array[mid]
	
	return middle_point

func debug_print_points():
	print("Start point: ", drawing_points[0])
	for i in range(1, drawing_points.size() - 1):
		print(drawing_points[i])
	print("  End point: ", drawing_points[-1])
