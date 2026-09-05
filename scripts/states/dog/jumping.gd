extends State

@onready var movement_component: MovementComponent = %MovementComponent

@export var running_state: State

func enter() -> void:
	movement_component.jump()
	switch_state.emit(running_state)

func physics_update(_delta: float) -> void:
	#if movement_component.is_on_floor():
		#switch_state.emit(running_state)
	pass
