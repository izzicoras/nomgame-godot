extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.struggle.set_state("brace")
	
	return SUCCESS
