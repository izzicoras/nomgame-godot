extends Node2D

signal player_enter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_nom_box_body_entered(body: Node2D) -> void:
	if body.name == "player":
		_eat_player(body)
		player_enter.emit(body)
		
func _eat_player(body: Node2D) -> void:
	body.global_position = $MouthPosition.global_position
	body.disable_controls()
	$Animation.play("snap")
	await $Animation.animation_finished
	$Animation.play("full")
	
