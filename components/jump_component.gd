class_name JumpComponent
extends Node

@export var jump_velocity: float = -250.0
@export var jump_velocity_offset: float = -250.0
@export var variable_jump_timing: int = 250

var is_jumping: bool = false
var time_since_on_floor = 0
var time_since_last_jump_addition = 0

func reset_time_on_floor() -> void:
	time_since_on_floor = Time.get_ticks_msec()

func handle_jump(body: CharacterBody2D, is_jump_positioned: Callable, jump_pressed: bool, jump_held: bool) -> void:
	if body.is_on_ceiling():
		time_since_on_floor -= 100000;
	
	if is_jump_positioned.call():
		reset_time_on_floor()
		is_jumping = false
	
	if jump_pressed and (
		body.is_on_floor()
		or ((Time.get_ticks_msec() - time_since_on_floor) < 200)
	):
		time_since_last_jump_addition = Time.get_ticks_msec()
		body.velocity.y = jump_velocity
		is_jumping = true
		
	if is_jumping and jump_held and (Time.get_ticks_msec() - time_since_on_floor) < variable_jump_timing:
		body.velocity.y -=  (time_since_last_jump_addition - Time.get_ticks_msec()) * jump_velocity_offset / variable_jump_timing
		time_since_last_jump_addition = Time.get_ticks_msec()
