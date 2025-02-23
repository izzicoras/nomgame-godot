class_name PlayerStruggleComponent
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

var states = ["attack", "brace", "rest"]
var state_index = 0

func can_attack() -> bool:
	return energy_component.can_exert(attack_cost)
			
func can_brace() -> bool:
	return energy_component.can_exert(brace_cost)

func _ready() -> void:
	brace_component.register(health_component)
	
	health_component.health_change.connect(func(value: float, previous: float): print("player Health:", value))
	energy_component.energy_change.connect(func(value: float, previous: float): print("player Energy:", value))
	
	recurring_damage_component.before_attack.connect(_on_before_attack)
	brace_component.before_brace.connect(_on_before_brace)
	
	recurring_damage_component.attack.connect(func(): energy_component.exhaust(attack_cost))
	brace_component.brace.connect(func(): energy_component.exhaust(brace_cost))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("previous_state"):
		previous_state()
	if Input.is_action_just_pressed("next_state"):
		next_state()
		
	var state = states[state_index]
	
	if state == "attack":
		if recurring_damage_component.is_active == false:
			recurring_damage_component.activate()
			state_update.emit("attack")
			print("player attack")
	else:
		if recurring_damage_component.is_active:
			recurring_damage_component.deactivate()
			
	if state == "brace":
		if brace_component.is_active == false:
			brace_component.activate()
			state_update.emit("brace")
			print("player brace")
	else:
		if brace_component.is_active:
			brace_component.deactivate()
			
	if state == "rest":
		if energy_component.is_active == false:
			energy_component.activate()
			state_update.emit("rest")
			print("player rest")
	else:
		if energy_component.is_active:
			energy_component.deactivate()

func next_state():
	state_index = (state_index + 1) % states.size()

func previous_state():
	state_index = (state_index - 1 + states.size()) % states.size()

func _on_before_attack(prevent_attack: Callable) -> void:
	if can_attack() == false:
		prevent_attack.call()
		
func _on_before_brace(prevent_brace: Callable) -> void:
	if can_brace() == false:
		prevent_brace.call()
