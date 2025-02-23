class_name PlantEnemy
extends Node2D

signal player_enter

@onready var player_release_timer = $PlayerReleaseTimer

@export_category("Components")
@export var struggle: StruggleComponent
@export var health_component: HealthComponent
@export var recurring_damage_component: RecurringDamangeComponent
@export var brace_component: BraceComponent
@export var energy_component: EnergyComponent
@export var mouth: Marker2D
@export var sprite: AnimatedSprite2D

var player: Node2D

func _ready() -> void:
	health_component.health_change.connect(func (health, prev) -> void: print("Plant health: ", health))

func get_player() -> Node:
	return player
	
func release_player() -> void:
	player = null
	recurring_damage_component.unregister()
	player_release_timer.start()

func _on_nom_box_body_entered(body: Node2D) -> void:
	if body.name == "player" && player_release_timer.is_stopped():
		player = body
		player_enter.emit(self)
		recurring_damage_component.register(player.health_component)

func _on_nom_box_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		recurring_damage_component.unregister()
