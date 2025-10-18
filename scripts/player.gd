extends CharacterBody2D

var GRAVITY:float = 9.8
var SCALE:float = 10

var grav_vect:Vector2 = Vector2.DOWN
var speed_x:float = 0
var speed_y:float = 0
var last_saved = [Vector2.ZERO, Vector2.ZERO]
var speed = 500

@onready var ray = $RayCast2D
#@onready var grounded:bool = false # Does this need to exist?


func _physics_process(delta):
	ray.target_position = grav_vect*70
	up_direction=-grav_vect

	var vel_x = 0
	var vel_y = 0
	
	if is_on_ceiling():
		speed_y = 1
		speed_x = 1
	if is_on_floor():
		speed_x = 0
		speed_y = 0
	else:
		if(grav_vect == Vector2.RIGHT || grav_vect == Vector2.LEFT):
			vel_x = grav_vect.x*speed_x
			vel_y = velocity.y
			speed_x += GRAVITY*SCALE/60
		if(grav_vect == Vector2.UP || grav_vect == Vector2.DOWN):
			vel_x = velocity.x
			vel_y = grav_vect.y*speed_y
			speed_y += GRAVITY*SCALE/60
	
	velocity = Vector2(vel_x,vel_y)
	move_and_slide()

func _process(delta):
	var gesture = GameManager.gesture
	grav_vect = GameManager.gesture_map[gesture]
	
	match gesture:
		"Λ", "V":
			if (gesture == "Λ" and last_saved[0] == Vector2.DOWN) || (gesture == "V" and last_saved[0] == Vector2.UP):
				speed_y *= -1
			last_saved[0] = grav_vect
			speed_y += 1
		"<", ">":
			if (gesture == "<" and last_saved[1] == Vector2.RIGHT) || (gesture == ">" and last_saved[1] == Vector2.LEFT):
				speed_x *= -1
			last_saved[1] = grav_vect
			speed_x += 1
	
	#print("speed_x: ", speed_x)
	#print("speed_y: ", speed_y)	
