class_name Player extends Character
@onready var package: CSGBox3D = $Package
@onready var state_machine: StateMachine = $StateMachine
@onready var idle: State = $StateMachine/Idle
@onready var immobile: State = $StateMachine/Immobile

func add_box() -> void:
	package.show()

func stop() -> void:
	state_machine.change_state(immobile)
