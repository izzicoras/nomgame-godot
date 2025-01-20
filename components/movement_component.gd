class_name MovementComponent
extends Node

@export var speed: float = 200.0
@export var ground_accel_speed: float = 10.0
@export var ground_decel_speed: float = 12.0
@export var air_accel_speed: float = 18.0
@export var air_decel_speed: float = 5.0

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	var velocity_speed_change: float = 0.0
	
	if body.is_on_floor():
		velocity_speed_change = ground_accel_speed if direction != 0.0 else ground_decel_speed
	else:
		velocity_speed_change = air_accel_speed if direction != 0.0 else air_decel_speed
		
	body.velocity.x = move_toward(body.velocity.x, direction * speed, velocity_speed_change)
