extends KinematicBody

const mouse_sen=0.1

onready var cam=$cam/Camera

var velocity=Vector3.ZERO

var currentvel=Vector3.ZERO

var dir=Vector3.ZERO

var jmp_count=0

const gravity=-15.0
const jump=8.0
const speed=10.0
const sprint=20.0
const acc=18.0
const acc1=5.0




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	_window_activity()
	
func _physics_process(delta):
	dir=Vector3.ZERO
	if Input.is_action_pressed("w"):
		dir-=cam.global_transform.basis.z
	if Input.is_action_pressed("s"):
		dir+=cam.global_transform.basis.z
	if Input.is_action_pressed("a"):
		dir-=cam.global_transform.basis.x
	if Input.is_action_pressed("d"):
		dir+=cam.global_transform.basis.x
	
	dir=dir.normalized()
	
	velocity.y+=gravity*delta
	
	if is_on_floor():
		jmp_count=0
	
	if Input.is_action_just_pressed("space") and jmp_count<2:
		jmp_count+=1
		velocity.y=jump
		print("lockheadmartin")
	
	var speed1= sprint if Input.is_action_just_pressed("shift") else speed
	var final_vel=speed1*dir
	
	var accl= acc if is_on_floor() else acc1
	currentvel=currentvel.linear_interpolate(final_vel,accl*delta)
	
	velocity.x=currentvel.x
	velocity.z=currentvel.z
	move_and_slide(velocity,Vector3.UP,true,4,deg2rad(80))
	
	

func _input(event):
	if event is InputEventMouseMotion:
		$cam.rotate_x(deg2rad(event.relative.y * mouse_sen*-1))
		$cam.rotation_degrees.x=clamp($cam.rotation_degrees.x,-75,90)
		
		self.rotate_y((deg2rad(event.relative.x*mouse_sen*-1)))

func _window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
