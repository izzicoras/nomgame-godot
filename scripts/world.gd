extends Node2D

@export_category("Components")
@export var plant_manager: PlantManager
@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	for enemy in enemies:
		plant_manager.add_plant(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
