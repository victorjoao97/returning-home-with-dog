class_name CameraComponent extends Node

@export var camera: Camera3D
@export var spring_arm: SpringArm3D
@export var mouse_sensibility := 0.005
@export var follow_mouse := false

func _ready() -> void:
	if follow_mouse:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func move_camera_to(target: Marker3D) -> void:
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		camera,
		"global_position",
		target.global_position,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		camera,
		"global_rotation",
		target.global_rotation,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _unhandled_input(event: InputEvent) -> void:
	if follow_mouse and event is InputEventMouseMotion:
		spring_arm.rotation.y -= event.relative.x * mouse_sensibility
		spring_arm.rotation.y = wrapf(spring_arm.rotation.y, 0.0, TAU)
		spring_arm.rotation.x -= event.relative.y * mouse_sensibility
		spring_arm.rotation.x = clampf(spring_arm.rotation.x, -PI / 2, PI / 4)

	if Input.is_action_just_pressed("exit"):
		follow_mouse = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			follow_mouse = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
