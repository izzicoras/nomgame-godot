extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.player.disable_controls()
	
	actor.player.global_position.x = move_toward(
		actor.player.global_position.x,
		actor.mouth.global_position.x,
		1
	)
	
	actor.player.global_position.y = move_toward(
		actor.player.global_position.y,
		actor.mouth.global_position.y,
		1
	)
	
	if (
		actor.player.global_position.x == actor.mouth.global_position.x
		and actor.player.global_position.y == actor.mouth.global_position.y
	):
		return SUCCESS
	else:
		return RUNNING
