extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if (actor.sprite.animation != "idle"):
		actor.sprite.play("idle")
	
	return SUCCESS
