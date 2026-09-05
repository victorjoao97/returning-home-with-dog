extends Camera3D

@export var player: CharacterBody3D
@export var mouse_sens: float = 0.002

#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotation.y -= event.relative.x * mouse_sens
		#rotation.x -= event.relative.y * mouse_sens
	#
	#if event.is_action_pressed("exit"):
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
