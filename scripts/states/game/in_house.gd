extends State

@export var outside_house_state: State
@export var mailman_sequence: MailmanSequence
@export var input_component: InputComponent

func enter() -> void:
	mailman_sequence.finished.connect(
		_on_mailman_sequence_finished
	)

	mailman_sequence.start()

func physics_update(_delta: float) -> void:
	if input_component.is_interact_pressed:
		mailman_sequence.try_interact()

func _on_mailman_sequence_finished() -> void:
	switch_state.emit(outside_house_state)
