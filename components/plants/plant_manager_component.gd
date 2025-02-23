class_name PlantManager
extends Node

@export_category("Components")
@export var player: Player
@export var ui: PlantStruggleUI

var plants = []

func add_plant(plant: PlantEnemy) -> void:
	plants.append(plant)
	plant.player_enter.connect(_on_player_capture)
	plant.struggle.state_update.connect(_on_plant_state_update)
	player.struggle.state_update.connect(_on_player_state_update)
	plant.health_component.health_change.connect(
		func (health, previous) -> void: _on_plant_health_change(health, plant)
	)

func _on_plant_state_update(state) -> void:
	ui.setPlantState(state)
	
func _on_player_state_update(state) -> void:
	ui.setPlayerState(state)
	
func _on_plant_health_change(health: float, plant: PlantEnemy) -> void:
	print("check: ", health, " ", health == 0.0)
	
	if health == 0.0:
		player.recurring_damange_component.unregister()
		plant.recurring_damage_component.unregister()
		plant.release_player()
		plant.health_component.set_full_health()
		player.are_controls_disabled = false
		ui.visible = false
		

func _on_player_capture(plant: PlantEnemy) -> void:
	ui.visible = true
	player.recurring_damange_component.register(plant.health_component)
	plant.recurring_damage_component.register(player.health_component)
