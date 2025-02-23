class_name EnergyComponent
extends Node

signal before_energy_change
signal energy_change

@export_category("Properties")
@export var max_energy: float = 200.0
@export var energy: float = 200.0
@export var revitalize_amount: float = 10.0
@export var revitalize_speed: float = 1.0
@export var is_active: bool = false

func proportion() -> float:
	return energy / max_energy

func can_exert(energy_to_be_consumed: float) -> bool:
	return energy >= energy_to_be_consumed

func exhaust_if_can(consumed_energy: float) -> void:
	if can_exert(consumed_energy):
		exhaust(consumed_energy)

func exhaust(consumed_energy: float) -> void:
	_change_energy(energy - consumed_energy)
	
func revitalize(revitalized_energy: float) -> void:
	_change_energy(energy + revitalized_energy)

func deactivate() -> void:
	activate(false)
	
func activate(activate = true) -> void:
	is_active = activate
	if is_active:
		$RevitalizeTimer.start()
	else:
		$RevitalizeTimer.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	$RevitalizeTimer.connect("timeout", self._on_revitalisation)
	$RevitalizeTimer.wait_time = revitalize_speed

func _on_revitalisation() -> void:
	if is_active:
		revitalize(revitalize_amount)
		
func _change_energy(value: float) -> void:
	var previous = energy
	var is_energy_set_before = false
	var set_energy_before = func (before_energy: int):
		value = before_energy
		is_energy_set_before = true
	
	before_energy_change.emit(value, energy, set_energy_before)
	
	if is_energy_set_before == false: 
		energy = min(max(0, value), max_energy)
	
	if energy != previous:
		energy_change.emit(energy, previous)
