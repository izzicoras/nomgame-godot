extends Control

@export_category("Components")
@export var player: Player

@export_category("Properties")
@export var sprite_count: int = 19
@export var sprite_width: int = 10

@onready var energy_stat = $EnergyStat
@onready var health_stat = $HealthStat

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_stat.region_rect.position.x = (
		floor(
			(1 - player.health_component.proportion())
			* sprite_count
		) * sprite_width
	)
	
	energy_stat.region_rect.position.x = (
		floor(
			(1 - player.energy_component.proportion())
			* sprite_count
		) * sprite_width
	)
