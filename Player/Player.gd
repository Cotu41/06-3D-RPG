extends KinematicBody

onready var Camera = get_node("/root/Main/CameraContainer/Camera")

var health = 100
var velocity = Vector3()
var gravity = -9.8
export var speed = 10
export var friction = 5
export var max_speed = 15
var jump = 2
var rolling = false
var mouselocked = true
var in_rotation_control = true
var is_moving = false
var friction_vec
var isAttacking = false
export var attackTime = 0.8
var attackCountdown = 0
export var roll_factor = 3
export var rollTime = 0.3
var rollCountdown = 0
var rollDir
export var attackDuration = 1

func _ready():
	$AnimationPlayer.play("Idle")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	
	velocity.y += gravity * delta
	var desired_velocity = get_input() * speed * delta
	if rolling:
		desired_velocity = rollDir * speed * delta * roll_factor
	velocity.x += desired_velocity.x
	velocity.z += desired_velocity.z
	if not is_moving and not rolling:
		velocity.x *= 0.10
		velocity.z *= 0.10
	
	

	
	
	
	var current_speed = velocity.length()
	if not rolling:
		velocity = velocity.normalized() * clamp(current_speed, 0, max_speed)
	$AnimationTree.set("parameters/Idle_Walk/blend_amount", current_speed/max_speed) 
	var flat_v = Vector2(velocity.x, velocity.z)
	if flat_v.length() > 0:
		look_at(Vector3(global_transform.origin.x-velocity.x, 
		global_transform.origin.y, 
		global_transform.origin.z-velocity.z), 
		Vector3.UP)
	
	friction_vec = -1 * friction * delta * velocity.normalized()
	friction_vec.y = 0
	if abs(desired_velocity.x) > 1: friction_vec.x = 0
	if abs(desired_velocity.z) > 1: friction_vec.z = 0
	
	if not rolling:
		velocity += friction_vec
		if current_speed > max_speed:
			velocity += friction_vec
	if isAttacking:
		if attackCountdown >= attackTime:
			isAttacking = false
		else:
			attackCountdown += delta
			
		velocity *= 0.75
			
			
			
	velocity = move_and_slide(velocity, Vector3.UP, true)


	
	if rolling:
		if rollCountdown >= rollTime:
			rolling = false
			velocity.x *= 0.25
			velocity.z *= 0.25
		else:
			rollCountdown += delta





func get_input():
	var input_dir = Vector3()
	is_moving = false
	
	
	
	
	if Input.is_action_just_pressed("attack") and not isAttacking and not rolling:
		attackCountdown = 0
		isAttacking = true
		$AnimationTree.set("parameters/AttackOS/active", true)
		
	if Input.is_action_just_pressed("drink potion") and not isAttacking and not rolling:
		if $Potion.use():
			health = 100

		
	if not rolling:
		if Input.is_action_pressed("forward"):
			input_dir += -Camera.global_transform.basis.z
			is_moving = true
		if Input.is_action_pressed("backward"):
			input_dir += Camera.global_transform.basis.z
			is_moving = true
		if Input.is_action_pressed("left"):
			input_dir += -Camera.global_transform.basis.x
			is_moving = true
		if Input.is_action_pressed("right"):
			input_dir += Camera.global_transform.basis.x
			is_moving = true
			
	if Input.is_action_pressed("roll") and not isAttacking and not rolling:
		rolling = true
		rollCountdown = 0
		is_moving = true
		rollDir = input_dir.normalized()
		$AnimationTree.set("parameters/RollOS/active", true)

	if Input.is_action_just_pressed("menu"):
		if mouselocked:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouselocked = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouselocked = true
	input_dir = input_dir.normalized()
	
	return input_dir
