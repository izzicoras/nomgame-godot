class_name PlantStruggleUI
extends Control

var player_state = "rest"
var plant_state = "rest"

var plant_states = {
	"brace": [16.0, 0, 8.0],
	"attack": [0.0, 8.0, 16.0],
	"rest": [0.0, 16, 8.0],
}

var player_states = {
	"brace": [16.0, 0.0, 8.0],
	"attack": [0.0, 8.0, 16.0],
	"rest": [0.0, 16.0, 8.0],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Plant1.texture.region.position.x = plant_states[plant_state][0]
	$Plant2.texture.region.position.x = plant_states[plant_state][1]
	$Plant3.texture.region.position.x = plant_states[plant_state][2]	
	$Player1.texture.region.position.x = player_states[player_state][0]
	$Player2.texture.region.position.x = player_states[player_state][1]
	$Player3.texture.region.position.x = player_states[player_state][2]
	
func setPlantState(state: String) -> void:
	plant_state = state
	
func setPlayerState(state: String) -> void:
	player_state = state
