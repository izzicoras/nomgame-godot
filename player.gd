extends CharacterBody2D

signal speed_update

@export_category("Components")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var jump_component: JumpComponent
@export var wall_slide_component: WallSlideComponent

var are_controls_disabled: bool = false

func disable_controls() -> void:
	are_controls_disabled = true

func _ready() -> void:
	$Animation.play()

func _process(delta: float) -> void:
	animatePlayer()

func _physics_process(delta: float) -> void:
	if (are_controls_disabled):
		return
	
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)	
	wall_slide_component.handle_wall_slide(
		self,
		delta,
		input_component.input_horizontal,
		input_component.get_jump_input()
	)
	
	jump_component.handle_jump(
		self,
		is_able_to_jump,
		input_component.get_jump_input(),
		input_component.get_jump_input_held()
	)
	
	move_and_slide()

func is_able_to_jump() -> bool:
	return wall_slide_component.is_able_to_jump() or is_on_floor()

func animatePlayer():
	if is_on_floor():
		if velocity.x != 0:
			$Animation.animation = "run"
		else:
			$Animation.animation = "idle"			
	else:
		if velocity.y >= 0:
			$Animation.animation = "falling"
		else:
			$Animation.animation = "jump"
			
	if wall_slide_component.is_wall_sliding:
		$Animation.animation = "wall_cling"
		
	if velocity.x > 0:
		$Animation.flip_h = false
	elif velocity.x < 0:
		$Animation.flip_h = true
