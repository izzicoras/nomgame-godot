class_name WallSlideComponent
extends Node

var is_wall_sliding: bool = false
var wall_normal: float = 0.0
var prev_wall_normal: float = 0.0

func is_able_to_jump() -> bool:
	print(wall_normal, prev_wall_normal)
	
	return wall_normal != prev_wall_normal

func handle_wall_slide(body: CharacterBody2D, delta: float, direction: float, is_jump_pressed) -> void:
	if body.is_on_floor():
		wall_normal = 0.0
		
	if is_jump_pressed: 
		prev_wall_normal = wall_normal
		wall_normal = 0.0
	
	if body.is_on_wall() and body.get_wall_normal().x == -direction and body.velocity.y > 0:
		body.velocity.y *= 0.5
		is_wall_sliding = true
		wall_normal = body.get_wall_normal().x
	else: 
		is_wall_sliding = false	
