class_name HealthComponent
extends Node

signal before_health_change
signal health_change

@export_category("Properties")
@export var max_health: float = 200.0
@export var health: float = max_health

func proportion() -> float:
	return health / max_health

func set_full_health() -> void:
	_change_health(max_health)

func damage(value: float) -> void:
	_change_health(health - value)

func heal(value: float) -> void:
	_change_health(health + value)
	
func _change_health(value: float) -> void:
	var previous = health
	var is_health_set_before = false
	var set_health_before = func (before_health: int):
		value = before_health
		is_health_set_before = true
	
	before_health_change.emit(value, health, set_health_before)
	
	if is_health_set_before == false: 
		health = min(max(0, value), max_health)
	
	if health != previous:
		health_change.emit(health, previous)
