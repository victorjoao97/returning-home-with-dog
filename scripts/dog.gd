class_name Dog extends Character
@onready var state_machine: StateMachine = $StateMachine
@onready var escaping: State = $StateMachine/Escaping
@onready var idle: State = $StateMachine/Idle
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func start_escape() -> void:
	animation_player.play("Dog1_Run")
	state_machine.change_state(escaping)

func stop_escape() -> void:
	animation_player.play("Dog1_Bark")
	state_machine.change_state(idle)
