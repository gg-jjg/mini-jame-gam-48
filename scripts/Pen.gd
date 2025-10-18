extends Node2D

var points = []
var last_point = Vector2.ZERO
const DISTANCE_THRESHOLD = 100.0
@onready var line = $Line2D

func _input(event):
	if Input.is_action_just_pressed("write"):
		points.clear() # Clear previous points on new write
		last_point = event.position
		points.append(last_point)
		#print('Write: start')
	
	elif event is InputEventMouseMotion and Input.is_action_pressed("write"):
		# Track mouse movement while writing
		var distance = last_point.distance_to(event.position)

		if distance > DISTANCE_THRESHOLD:
			last_point = event.position
			points.append(last_point)
			#print("  Captured point")
	
	elif Input.is_action_just_released("write"):
		points.append(event.position)
		
		var three_points = get_three_points(points)
		draw_three_points(three_points)
		#print('Write: end')
		#debug_print_points()

func get_three_points(points_array):
	var mid_point = get_middle_point(points)
	var three_points = [points_array[0], mid_point, points_array[len(points_array) - 1]]
	
	return three_points

func draw_three_points(points):
	#Draws a line connecting the start point, the midpoint, and the end point of the given points array.
	line.clear_points() # Clear previous line on new write
	
	for point in points:
		line.add_point(point)

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
	print("Start point: ", points[0])
	for i in range(1, points.size() - 1):
		print(points[i])
	print("  End point: ", points[-1])
