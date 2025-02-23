class_name StruggleComponent
extends Node

signal state_update

@export_category("Properties")
@export var attack_cost: float = 20.0
@export var brace_cost: float = 20.0

@export_category("Components")
@export var recurring_damage_component: RecurringDamangeComponent
@export var brace_component: BraceComponent
@export var energy_component: EnergyComponent
@export var health_component: HealthComponent

var brace_priority_offset = 0
var attack_priority_offset = 0
var rest_priority_offset = 0

func can_attack() -> bool:
	return energy_component.can_exert(attack_cost)
			
func can_brace() -> bool:
	return energy_component.can_exert(brace_cost)

func attack_priority() -> float:
	var priority = 0.0
	priority -= health_component.proportion()
	priority += energy_component.proportion() * 2.5
	priority += attack_priority_offset
	return priority

func rest_priority() -> float:
	var priority = 0.0
	priority += health_component.proportion()
	priority -= energy_component.proportion()
	priority += rest_priority_offset
	return priority
	
func brace_priority() -> float:
	var priority = 2.0
	priority -= health_component.proportion()
	priority -= energy_component.proportion()
	priority += brace_priority_offset
	return priority

func _ready() -> void:
	brace_component.register(health_component)
	
	health_component.health_change.connect(func(value: float, previous: float): print("Health:", value))
	energy_component.energy_change.connect(func(value: float, previous: float): print("Energy:", value))
	
	health_component.health_change.connect(_on_health_change)
	
	recurring_damage_component.before_attack.connect(_on_before_attack)
	brace_component.before_brace.connect(_on_before_brace)
	
	recurring_damage_component.attack.connect(func(): energy_component.exhaust(attack_cost))
	brace_component.brace.connect(func(): energy_component.exhaust(brace_cost))

func _process(delta: float) -> void:
	if _can_attack():
		attack_priority_offset = max(0.0, attack_priority_offset - 0.1 * delta)
		if recurring_damage_component.is_active == false:
			recurring_damage_component.activate()
			attack_priority_offset += 1.0
			state_update.emit("attack")
			print("attack")
	else:
		attack_priority_offset = 0.0
		if recurring_damage_component.is_active:
			recurring_damage_component.deactivate()
			
	if _can_brace():
		brace_priority_offset = max(0.0, brace_priority_offset - 0.1 * delta)
		if brace_component.is_active == false:
			brace_component.activate()
			brace_priority_offset += 1.0
			state_update.emit("brace")
			print("brace")
	else:
		brace_priority_offset = 0.0
		if brace_component.is_active:
			brace_component.deactivate()
			
	if ! _can_brace() and ! _can_attack():
		rest_priority_offset = max(0.0, rest_priority_offset - 0.1 * delta)
		if energy_component.is_active == false:
			energy_component.activate()
			rest_priority_offset += 1.0
			state_update.emit("rest")
			print("rest")
	else:
		rest_priority_offset = 0.0
		if energy_component.is_active:
			energy_component.deactivate()

func _can_attack() -> bool:
	return (
		energy_component.can_exert(attack_cost)
		and attack_priority() > brace_priority()
		and attack_priority() > rest_priority()
	)
			
func _can_brace() -> bool:
	return (
		energy_component.can_exert(brace_cost)
		and brace_priority() > attack_priority()
		and brace_priority() > rest_priority()
	)
	
func _on_health_change(health: float, previous: float) -> void:
	brace_priority_offset += 0.1
	
func _on_before_attack(prevent_attack: Callable) -> void:
	if can_attack() == false:
		prevent_attack.call()
		
func _on_before_brace(prevent_brace: Callable) -> void:
	if can_brace() == false:
		prevent_brace.call()
