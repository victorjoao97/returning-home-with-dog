extends State
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var running_state: State
@export var jumping_state: State
@export var input_component: InputComponent

var enabled := false

func enter() -> void:
	enabled = true
	animation_player.queue("idle/Root|Idle")

func exit() -> void:
	enabled = false

func physics_update(_delta: float) -> void:
	if !enabled:
		return

	var input_dir := input_component.input_direction
	
	if input_component.is_jumping_pressed:
		switch_state.emit(jumping_state)
		return

	if input_dir != Vector2.ZERO:
		switch_state.emit(running_state)
		return
