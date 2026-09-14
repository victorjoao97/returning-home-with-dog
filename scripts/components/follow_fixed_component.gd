class_name FollowTargetComponent extends Node

@export var target: Node3D
@export var source: Node3D

@export var max_speed := 5.0
@export var acceleration := 8.0
@export var stop_distance := 2.0
@export var rotation_speed := 8.0
@export var fixed_z := 2.0
@export var disabled := false
@export var enable_fixed_z := true
@export var enable_stop_distance := true

var velocity := Vector3.ZERO
var reached := false

signal target_reached

func _process(delta):
	if not target or not source:
		return

	if not target or not source:
		return

	# Direção no plano X/Y
	var direction := target.global_position - source.global_position

	var distance := direction.length()

	if distance <= stop_distance and not reached:
		reached = true
		target_reached.emit()
	if distance <= stop_distance and enable_stop_distance:
		velocity = velocity.move_toward(
			Vector3.ZERO,
			acceleration * delta
		)
	else:
		reached = false
		direction = direction.normalized()

		var target_velocity := direction * max_speed

		velocity = velocity.move_toward(
			target_velocity,
			acceleration * delta
		)

		# Rotação
		var target_rotation = atan2(-direction.x, -direction.y)

		source.rotation.y = lerp_angle(
			source.rotation.y,
			target_rotation,
			rotation_speed * delta
		)

	# Move apenas no X

	# Mantém o cachorro em um Z fixo
	if enable_fixed_z:
		source.global_position.z = fixed_z
		source.global_position.y += velocity.y * delta
		source.global_position.x += velocity.x * delta
	else:
		source.global_position.y += velocity.y * delta
		source.global_position.x += velocity.x * delta
		source.global_position.z += velocity.z * delta
