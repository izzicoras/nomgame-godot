extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.sprite.animation == "idle":
		actor.sprite.play("snap")
		
	if actor.sprite.is_playing():
		return RUNNING
	else:
		if actor.sprite.animation != "full":
			actor.sprite.play("full")
		return SUCCESS
