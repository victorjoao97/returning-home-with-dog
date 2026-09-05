extends State
@onready var movement_component: MovementComponent = %MovementComponent
@onready var dog: Dog = $"../.."

var enabled := false

func enter() -> void:
	enabled = true

func exit() -> void:
	enabled = false

func physics_update(_delta: float) -> void:
	if !enabled:
		return
	var input := movement_component.direction_to_input(dog.direction_to_follow)
	movement_component.move(input, _delta)
