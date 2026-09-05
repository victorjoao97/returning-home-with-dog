class_name GateHome extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func open_gate() -> void:
	animation_player.play("open")
	await animation_player.animation_finished

func close_gate() -> void:
	animation_player.play_backwards("open")
	await animation_player.animation_finished
