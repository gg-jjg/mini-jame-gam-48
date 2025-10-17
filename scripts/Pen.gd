extends Node2D

var drawing_points = []
@onready var line_2d = $Line2D
const DISTANCE_THRESHOLD = 100.0

var last_point = null
var angle = null


func _input(event):
	if Input.is_action_just_pressed("write"):
		drawing_points.clear() # Clear previous points on new write
		
		print('Write: start')
		last_point = event.position
		drawing_points.append(last_point)
	
	elif event is InputEventMouseMotion and Input.is_action_pressed("write"):
		# Track mouse movement while holding 'write'
		angle = get_movement_angle(last_point, event.position, drawing_points, DISTANCE_THRESHOLD)
		if angle:
			last_point = event.position
			drawing_points.append(last_point)
			print("  captured point")
	
	elif Input.is_action_just_released("write"):
		
		print('Write: end')
		drawing_points.append(event.position)
		print_points()
		
		draw_points(drawing_points)
	
func get_movement_angle(initial_point: Vector2, current_point: Vector2, recent_points: Array, distance_threshold: float):
	#Calculates the angle in degrees between initial_point and current_point if the movement
	#exceeds the distance_threshold. Uses recent_points (list of Vector2) to estimate velocity.
	
	#:param initial_point: The starting point of the gesture.
	#:param current_point: The current position of the mouse.
	#:param recent_points: Array of recent points for velocity calculation.
	#:param distance_threshold: The minimum distance to consider for angle calculation.
	#:return: The angle in degrees if movement exceeds threshold, else null.
	
	# Calculate total movement distance from initial point
		var distance = initial_point.distance_to(current_point)

		if distance < distance_threshold:
			# Not enough movement yet
			return null

		# Estimate velocity using recent points (if available)
		if recent_points.size() >= 2:
			var start = recent_points[0]
			var end = recent_points[-1]
			var delta_time = recent_points.size()  # Approximate, or you can include timestamps
			var velocity = (end - start).length() / delta_time if delta_time > 0 else 0
		else:
			# Fallback if no recent points
			var velocity = 1  # Default to 1 for simplicity

		# Calculate the vector from initial to current
		var vector = current_point - initial_point
		var angle_rad = atan2(vector.y, vector.x)
		var angle_deg = rad_to_deg(angle_rad)

		return angle_deg

func draw_points(points_array):
	line_2d.clear_points()
	for point in points_array:
		line_2d.add_point(point)

func print_points():
	print("Start point: ", drawing_points[0])
	for i in range(1, drawing_points.size() - 1):
		print(drawing_points[i])
	print("  End point: ", drawing_points[-1])
