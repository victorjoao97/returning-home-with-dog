extends State
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var idle_state: State
@export var running_state: State
@export var input_component: InputComponent
@export var movement_component: MovementComponent

var enabled := false

func enter() -> void:
	enabled = true
	movement_component.jump()
	animation_player.play("jump/Root|Jump")

func exit() -> void:
	enabled = false

func physics_update(_delta: float) -> void:
	if !enabled:
		return

	var input_dir := input_component.input_direction

	movement_component.move(input_dir, _delta)

	if movement_component.is_on_floor():
		if input_dir != Vector2.ZERO:
			switch_state.emit(running_state)
		else:
			switch_state.emit(idle_state)
		
