class_name RecurringDamangeComponent
extends Node

signal before_attack
signal attack

@export_category("Properties")
@export var attack_damange: float = 5.0
@export var attack_speed: float = 1.0
@export var is_active: bool = false

var health_component: HealthComponent = null 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DamageTimer.connect("timeout", self._on_damage_timer)
	$DamageTimer.wait_time = attack_speed
	
func deactivate() -> void:
	activate(false)
	
func activate(make_active = true) -> void:
	is_active = make_active
	if is_active:
		$DamageTimer.start()
	else:
		$DamageTimer.stop()

func register(health: HealthComponent) -> void:
	health_component = health
	
func unregister() -> void:
	health_component = null
	
func can_attack() -> bool:
	var is_attack_prevented = false
	var prevent_attack = func ():
		is_attack_prevented = true
	
	before_attack.emit(prevent_attack)
	
	return is_attack_prevented == false

func _on_damage_timer() -> void:
	if health_component:
		_attack()

func _attack() -> void:
	var can_perform_attack = can_attack()
	
	if can_perform_attack:
		health_component.damage(attack_damange)
		attack.emit()
