class_name GravityComponent
extends Node

var is_falling: bool = false

func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
		
	is_falling = body.velocity.y > 0 and body.is_not_on_floor()
