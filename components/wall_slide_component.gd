class_name WallSlideComponent
extends Node

@export var jumpoff_velocity: float = 250.0

var is_wall_sliding: bool = false
var wall_normal: float = 0.0
var wall_position: float = 0.0
var prev_wall_normal: float = 0.0
var prev_wall_position: float = 0.0
var epsilon: float = 0.01

func is_able_to_jump() -> bool:
	return is_wall_sliding
	return wall_normal != prev_wall_normal or abs(wall_position - prev_wall_position) > epsilon

func handle_wall_slide(body: CharacterBody2D, delta: float, direction: float, is_jump_pressed: bool) -> void:
	if body.is_on_floor():
		wall_normal = 0.0
		wall_position = 0.0
		
	if is_jump_pressed: 
		print("wall")
		body.velocity += Vector2.RIGHT * wall_normal * jumpoff_velocity
		prev_wall_normal = wall_normal
		prev_wall_position = wall_position
		wall_normal = 0.0
		wall_position = 0.0
	
	if body.is_on_wall() and body.get_wall_normal().x == -direction:
		body.velocity.y *= 0.5
		is_wall_sliding = true
		wall_normal = body.get_wall_normal().x
		wall_position = body.position.x
	else: 
		is_wall_sliding = false	
