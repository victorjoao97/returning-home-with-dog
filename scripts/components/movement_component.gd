class_name MovementComponent extends Node

@export var body: Character
@export var model: Node3D
@export var use_camera_rotation := false
@export var max_speed := 3.0
@export var acceleration := 25.0
@export var jump_velocity := 5.0
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
		direction *= max_speed
		body.velocity.x =  move_toward(body.velocity.x, direction.x, delta * acceleration)
		body.velocity.z = move_toward(body.velocity.z, direction.z, delta * acceleration)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, delta * acceleration)
		body.velocity.z = move_toward(body.velocity.z, 0, delta * acceleration)

	body.move_and_slide()

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
