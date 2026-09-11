class_name MovementComponent extends Node

@export var body: Character
@export var model: Node3D
@export var use_camera_rotation := false
@export var max_speed := 3.0
@export var acceleration := 25.0
@export var jump_velocity := 5.0
@export var rotation_speed := 8.0
@export var movement_mode := MovementMode.FREE

var jumping := false
var last_direction := Vector3.RIGHT
var body_velocity: Vector3:
	get:
		if !body:
			return Vector3.ZERO
		return body.velocity

enum MovementMode {
	FREE,
	AXIS_X,
	AXIS_Z
}

func jump() -> void:
	if body.is_on_floor() and body.can_jump:
		body.velocity.y = jump_velocity

func is_on_floor() -> bool:
	return body.is_on_floor()

func direction_to_input(direction: Vector3) -> Vector2:
	if direction == Vector3.ZERO:
		return Vector2.ZERO

	direction.y = 0
	direction = direction.normalized()

	var forward := body.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	var forward_input := forward.dot(direction)
	var turn_input := -forward.cross(direction).y

	return Vector2(forward_input, turn_input)

func move(input_dir: Vector2, delta: float) -> void:
	if !body:
		return
	
	_apply_gravity(delta)

	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if use_camera_rotation:
		direction = direction.rotated(Vector3.UP, get_viewport().get_camera_3d().global_rotation.y)
		
	
	if direction:
		var target_velocity := direction * max_speed
		body.velocity.x =  move_toward(body.velocity.x, target_velocity.x, delta * acceleration)
		body.velocity.z = move_toward(body.velocity.z, target_velocity.z, delta * acceleration)
		
		if body.velocity.length_squared() > 0.1:
			var _direction := Vector3(
				body.velocity.x,
				0.0,
				body.velocity.z
			).normalized()

			model.look_at(
				model.global_position + _direction,
				Vector3.UP
			)

			model.rotate_y(PI)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, delta * acceleration)
		body.velocity.z = move_toward(body.velocity.z, 0, delta * acceleration)

	body.move_and_slide()


func rotate_towards(input: Vector2, delta: float) -> void:
	if input.length_squared() > 0.001:
		input = input.normalized()

		var camera := get_viewport().get_camera_3d()
		var camera_forward := -camera.global_transform.basis.z
		var camera_right := camera.global_transform.basis.x

		camera_forward.y = 0.0
		camera_right.y = 0.0

		camera_forward = camera_forward.normalized()
		camera_right = camera_right.normalized()

		var direction := (
			camera_right * input.x +
			camera_forward * input.y
		).normalized()

		# Rotação
		var target_angle := atan2(
			direction.x,
			direction.z
		)

		model.rotation.y = lerp_angle(
			model.rotation.y,
			target_angle,
			rotation_speed * delta
		)


func _restrict_direction(direction: Vector3) -> Vector3:
	match movement_mode:
		MovementMode.FREE:
			return direction

		MovementMode.AXIS_X:
			return Vector3(direction.x, 0, 0).normalized()

		MovementMode.AXIS_Z:
			return Vector3(0, 0, direction.z).normalized()

	return direction

func _apply_gravity(delta: float) -> void:
	if body.is_on_floor():
		jumping = false
	else:
		body.velocity += body.get_gravity() * delta
		jumping = true
