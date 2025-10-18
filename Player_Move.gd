extends CharacterBody2D
@onready var game_manager = %GameManager

@onready var grav_dir:Vector2 = Vector2.DOWN
@onready var grav_const:float = 9.8
@onready var grav_scale:float = 100
@onready var gravity:float = 0
@onready var gravity2:float = 0
@onready var lastSaved = [Vector2.ZERO, Vector2.ZERO]
#@onready var grounded:bool = false
@onready var ray = $RayCast2D
var speed = 500
var inputs = {"right": Vector2.RIGHT, "left": Vector2.LEFT}

func _ready():
	up_direction=Vector2.UP
	
	
func get_input():
	
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			return inputs.get(dir)*speed
	return Vector2.ZERO

func _physics_process(delta):
	up_direction=-grav_dir

	ray.target_position = grav_dir*70
	#velocity= get_input() + grav_dir * gravity
	var velx = 0
	var vely = 0
	
	
	move_and_slide()
	if is_on_floor():
		gravity = 0
		gravity2 = 0
	else:
		if(grav_dir == Vector2.RIGHT || grav_dir == Vector2.LEFT):
			velx = grav_dir.x*gravity2
			vely = velocity.y
			gravity2 += grav_const*grav_scale/60
		if(grav_dir == Vector2.UP || grav_dir == Vector2.DOWN):
			velx = velocity.x
			vely = grav_dir.y*gravity
			gravity += grav_const*grav_scale/60
	velocity = Vector2(velx,vely)
	if is_on_ceiling():
		gravity = 1
		gravity2 = 1
	#if collision:
		#print("Collided")
		#gravity = 0
	#if ray.is_colliding():
		#print("yup")
		#gravity = 0
	#if !ray.is_colliding():
		#print ("nope")

func _process(delta):
	var gm_gravity = game_manager.get_gravity()
	
	if gm_gravity == 4:
		if(lastSaved[0] == Vector2.DOWN):
			gravity = -gravity
		grav_dir = Vector2.UP
		lastSaved[0] = grav_dir
		gravity += 1

	if gm_gravity == 0:
		if(lastSaved[0] == Vector2.UP):
			gravity = -gravity
		grav_dir = Vector2.DOWN
		lastSaved[0] = grav_dir
		gravity += 1

	if gm_gravity == 2:
		if(lastSaved[1] == Vector2.RIGHT):
			gravity2 = -gravity2
		grav_dir = Vector2.LEFT
		lastSaved[1] = grav_dir
		gravity2 += 1

	if gm_gravity == 6:
		if(lastSaved[1] == Vector2.LEFT):
			gravity2 = -gravity2
		grav_dir = Vector2.RIGHT
		lastSaved[1] = grav_dir
		gravity2 += 1

	#print(gravity,gravity2)
