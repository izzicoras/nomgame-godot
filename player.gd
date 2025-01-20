extends CharacterBody2D

signal speed_update

@export var speed: float = 200.0
@export var jump_velocity: float = -250.0
@export var jump_velocity_offset: float = -250.0
@export var ground_accel_speed: float = 10.0
@export var ground_decel_speed: float = 12.0
@export var air_accel_speed: float = 18.0
@export var air_decel_speed: float = 5.0
@export var variable_jump_timing: int = 250

var time_since_on_floor = 0
var time_since_last_jump_addition = 0
var is_jumping: bool = false
var is_wall_sliding: bool = false
var previous_slide_direction: float = 0.0
var are_controls_disabled: bool = false

func disable_controls() -> void:
	are_controls_disabled = true

func _physics_process(delta: float) -> void:
	if (are_controls_disabled):
		return
		
	var velocity_speed_change: float = 0.0
	var direction: float = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	if Input.is_action_pressed("move_left"):
		direction = -1.0
	elif Input.is_action_pressed("move_right"):
		direction = 1.0
		
	if is_on_floor():
		velocity_speed_change = ground_accel_speed if direction != 0.0 else ground_decel_speed
	else:
		velocity_speed_change = air_accel_speed if direction != 0.0 else air_decel_speed
		
	if is_on_floor():
		time_since_on_floor = Time.get_ticks_msec()
				
	$Animation.play()

	velocity.x = move_toward(velocity.x, direction * speed, velocity_speed_change)
		
	animatePlayer()
	handleWallJump(direction, delta)
	handleJump(delta)
	move_and_slide()

func handleWallJump(direction: float, delta: float) -> void: 
	if is_on_floor():
		previous_slide_direction = 0.0
	
	if is_on_wall() and velocity.y > 0 and direction != 0.0:
		velocity.y *= 0.5
		is_wall_sliding = true
		time_since_on_floor = Time.get_ticks_msec()
	else: 
		is_wall_sliding = false
		

func handleJump(delta: float) -> void:
	if (is_on_floor()):
		is_jumping = false
	
	if Input.is_action_just_pressed("jump") and (
		is_on_floor()
		or ((Time.get_ticks_msec() - time_since_on_floor) < 200)
		or is_wall_sliding
	):
		time_since_last_jump_addition = Time.get_ticks_msec()
		velocity.y = jump_velocity
		is_jumping = true
		
	if is_jumping and Input.is_action_pressed("jump") and (Time.get_ticks_msec() - time_since_on_floor) < variable_jump_timing:
		velocity.y -=  (time_since_last_jump_addition - Time.get_ticks_msec()) * jump_velocity_offset / variable_jump_timing
		time_since_last_jump_addition = Time.get_ticks_msec()
			
	

func animatePlayer():
	if is_on_floor():
		if velocity.x != 0:
			$Animation.animation = "run"
		else:
			$Animation.animation = "idle"			
	else:
		if velocity.y > 0:
			$Animation.animation = "falling"
		else:
			$Animation.animation = "jump"
			
	if is_wall_sliding:
		$Animation.animation = "wall_cling"
		
	if velocity.x > 0:
		$Animation.flip_h = false
	elif velocity.x < 0:
		$Animation.flip_h = true
