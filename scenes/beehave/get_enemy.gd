extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var entity = actor.player
	
	if entity == null:
		return FAILURE
	else: 
		return SUCCESS
