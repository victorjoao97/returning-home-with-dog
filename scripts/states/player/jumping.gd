extends State

@export var idle_state: State
@export var running_state: State
@export var input_component: InputComponent
@export var movement_component: MovementComponent

func enter() -> void:
	movement_component.jump()

func physics_update(_delta: float) -> void:
	var input_dir := input_component.input_direction

	movement_component.move(input_dir, _delta)

	if movement_component.is_on_floor():
		if input_dir != Vector2.ZERO:
			switch_state.emit(running_state)
		else:
			switch_state.emit(idle_state)
