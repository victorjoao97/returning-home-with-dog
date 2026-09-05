class_name Dog extends Character
@onready var state_machine: StateMachine = $StateMachine
@onready var escaping: State = $StateMachine/Escaping
@onready var idle: State = $StateMachine/Idle

func start_escape() -> void:
	state_machine.change_state(escaping)

func stop_escape() -> void:
	state_machine.change_state(idle)
