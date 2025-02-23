class_name BraceComponent
extends Node

signal before_brace
signal brace

@export_category("Properties")
@export var defense: float = 0.5
@export var is_active: bool = false

var health_component: HealthComponent = null 

func deactivate() -> void:
	activate(false)
	
func activate(activate = true) -> void:
	is_active = activate

func register(health: HealthComponent) -> void:
	health_component = health
	health_component.before_health_change.connect(_on_before_health_change)
	
func unregister() -> void:
	health_component.before_health_change.disconnect(_on_before_health_change)
	health_component = null

func can_brace() -> bool:
	var is_brace_prevented = false
	var prevent_brace = func ():
		is_brace_prevented = true
	
	before_brace.emit(prevent_brace)
	
	return is_brace_prevented == false

func _on_before_health_change(newHealth: float, previous: float, set_health: Callable) -> void:
	if is_active:
		_brace(newHealth, previous, set_health)

func _brace(value: float, previous: float, set_health: Callable) -> void:
	var can_perform_brace = can_brace()
	
	if can_perform_brace:
		set_health.call(previous - (previous - value) * defense)
		brace.emit()
