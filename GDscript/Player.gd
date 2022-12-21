extends KinematicBody

var speed = 7
var acceleration = 10
var gravity = 0.09
var jump = 10

var mouse_sensitivity = 0.03

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

onready var head = $Head
onready var weapon_manage = $Head/Weapon

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func controling_movement_inputs():
	direction = Vector3()
	
	#moving controling
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()


func _physics_process(delta):
	#move_and_slide(fall, Vector3.UP)
	
	if not is_on_floor():
		fall.y -= gravity
	
	#calling funtion inputs change weapon
	if Input.is_action_just_pressed("empty"):
		weapon_manage.change_weapon("Empty")
	if Input.is_action_just_pressed("primary"):
		weapon_manage.change_weapon("Primary")
	if Input.is_action_just_pressed("secondary"):
		weapon_manage.change_weapon("Secondary")
	
	#calling function input movement control
	controling_movement_inputs()
	
	
	# Firing
	if Input.is_action_pressed("fire"):
		weapon_manage.fire()
	if Input.is_action_just_released("fire"):
		weapon_manage.fire_stop()
	
	# Reloading
	if Input.is_action_just_pressed("reload"):
		weapon_manage.reload()
	
	
	#show the cursor mouse
	if Input.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else :
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 
