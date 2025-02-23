extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.brace_component.can_brace():
		return SUCCESS
	else:
		return FAILURE
