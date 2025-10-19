extends CharacterBody2D

@export var selectable = true
@export var grav_h = true
@export var grav_v = true
@export var GRAVITY:float = 9.8
@export var SCALE:float = 10
var gesture  = "V" #default, will be changed by either GM gesture or default_gesture if keep_gravity is disabled


@export var keep_gravity = true #if set to false, object will go back to default gravity (below) when not selected.
@export var default_gesture = "V"


var speed_x:float = 0
var speed_y:float = 0
var grav_vect:Vector2 = Vector2.DOWN
var last_saved = [Vector2.ZERO, Vector2.ZERO]

func set_selected(): #called by mouse_select, just tells game manager that this is the currently selected object
	GameManager.selected_object = self
	GameManager.set_gesture(gesture) #set GM gravity to the object's CURRENT gravity, that way it doesn't start moving right as you select it
	return #idk why this is here I don't fell like getting rid of it

func _process(_delta):
	
	if GameManager.selected_object != self: #if we are NOT the selected object
		if !keep_gravity: #if keep gravity is turned off, revert to our original/default gravity
			gesture = default_gesture
		else: #if we aren't reverting to default gravity then don't do anything
			return
	else: #if we ARE selected, sync with the GM gravity so that the pen can update us
		gesture = GameManager.gesture
	grav_vect = GameManager.gesture_map[gesture] #regardless of whether we're selected, check GM for the gravity vector corresponding to our gesture (this is here so that keep_gravity false works)
	
	
	
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

func _physics_process(_delta):

	up_direction=-grav_vect #used to check if we're on floors or ceilings

	var vel_x = 0
	var vel_y = 0
	
	if is_on_ceiling(): #for some reason it gets stuck sometimes so this gives it a little boost
		speed_y = 1
		speed_x = 1
	if is_on_floor(): #stop moving if we're on the floor
		speed_x = 0
		speed_y = 0
	else: #if we're not on the floor, set up our x and y velocities (so that if we change gravity we keep coasting a bit)
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
