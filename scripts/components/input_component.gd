class_name InputComponent extends Node

@export var joy_vibration := false

var is_jumping_pressed: bool:
	get:
		return Input.is_action_just_pressed("jump")
var is_interact_pressed: bool:
	get:
		return Input.is_action_just_pressed("interact")
var is_start_pressed: bool:
	get:
		return Input.is_action_just_pressed("start")

var direction := Vector3.ZERO
var joy_devices: Array[int] = []

var input_direction: Vector2:
	get:
		return Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		)

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device: int, connected: bool):
	if connected:
		if !joy_devices.has(device):
			joy_devices.append(device)
	else:
		if joy_devices.has(device):
			joy_devices.erase(device)

func handle_vibration() -> void:
	if !joy_vibration:
		return

	for device in joy_devices:
		Input.start_joy_vibration(device, randf_range(0.1, 0.3), 0, randf_range(0.1, 0.3))
