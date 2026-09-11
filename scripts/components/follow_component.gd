class_name FollowComponent extends Node

@export var target: Node3D
@export var source: Node3D
@export var navigation_agent: NavigationAgent3D

@export_category("Movement")
@export var max_speed := 5.0
@export var acceleration := 10.0
@export var deceleration := 15.0

@export_category("Navigation")
@export var time := 0.0
@export var follow_distance := 2.0

@export_category("Rotation")
@export var rotation_speed := 8.0

var amount_time := 0.0
var current_velocity := Vector3.ZERO

signal following
signal stopped

func _physics_process(delta: float) -> void:
	# =========================================================
	# 1. Atualiza o NavigationAgent periodicamente
	# =========================================================

	#amount_time += delta
#
	#if amount_time >= time:
		#amount_time = 0.0
	navigation_agent.target_position = target.global_position


	# =========================================================
	# 2. Verifica se o NavigationAgent está pronto
	# =========================================================

	if NavigationServer3D.map_get_iteration_id(
		navigation_agent.get_navigation_map()
	) == 0:
		stopped.emit()
		return

	if navigation_agent.is_navigation_finished():
		_slow_down(delta)
		stopped.emit()
		return


	# =========================================================
	# 3. Verifica distância até o alvo
	# =========================================================

	var distance := target.global_position.distance_to(
		source.global_position
	)

	if distance <= follow_distance:
		_slow_down(delta)
		stopped.emit()
		return


	# =========================================================
	# 4. Pega o próximo ponto do caminho
	# =========================================================

	var next_path_position := navigation_agent.get_next_path_position()

	var direction := (
		next_path_position - source.global_position
	)

	direction.y = 0.0

	if direction.length_squared() <= 0.001:
		_slow_down(delta)
		stopped.emit()
		return

	direction = direction.normalized()


	# =========================================================
	# 5. Aceleração
	# =========================================================

	var target_velocity := direction * max_speed

	current_velocity = current_velocity.move_toward(
		target_velocity,
		acceleration * delta
	)


	# =========================================================
	# 6. Movimento
	# =========================================================

	source.global_position += current_velocity * delta


	# =========================================================
	# 7. Rotação suave
	# =========================================================

	_rotate_towards(direction, delta)
	following.emit()

func _slow_down(delta: float) -> void:
	current_velocity = current_velocity.move_toward(
		Vector3.ZERO,
		deceleration * delta
	)

	source.global_position += current_velocity * delta


func _rotate_towards(direction: Vector3, delta: float) -> void:
	if direction.length_squared() <= 0.001:
		return

	var target_angle := atan2(
		direction.x,
		direction.y
	)

	source.rotation.y = lerp_angle(
		source.rotation.y,
		target_angle,
		rotation_speed * delta
	)
