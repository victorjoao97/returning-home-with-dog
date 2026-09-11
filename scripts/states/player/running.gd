extends State
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var idle_state: State
@export var jumping_state: State
@export var input_component: InputComponent
@export var movement_component: MovementComponent

var enabled := false

func enter() -> void:
	enabled = true
	animation_player.play("run/Root|Run")

func exit() -> void:
	enabled = false
	animation_player.stop()

func physics_update(_delta: float) -> void:
	if !enabled:
		return

	var input_dir := input_component.input_direction

	if input_component.is_jumping_pressed:
		switch_state.emit(jumping_state)
		return

	movement_component.move(input_dir, _delta)
	animation_player.queue("run/Root|Run")
	
	if not movement_component.is_on_floor():
		switch_state.emit(jumping_state)
		return

	if input_dir == Vector2.ZERO:
		switch_state.emit(idle_state)
