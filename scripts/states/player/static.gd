extends State

@export var player: Player

func enter() -> void:
	player.process_mode = Node.PROCESS_MODE_DISABLED
