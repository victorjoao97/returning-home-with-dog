extends Node3D

signal dog_following(value: bool)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene.call_deferred()
	
	if event.is_action_pressed("dog_stay"):
		dog_following.emit(false)
	
	if event.is_action_pressed("dog_come"):
		dog_following.emit(true)
