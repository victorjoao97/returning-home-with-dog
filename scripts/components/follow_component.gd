class_name FollowComponent extends Node

@export var target: Node3D
@export var source: Node3D
@export var navigation_agent: NavigationAgent3D
@export var follow_distance := 3.5

func _ready() -> void:
	navigation_agent.target_position = target.global_position

func get_next_direction() -> Vector3:
	navigation_agent.target_position = target.global_position
	# Aguarda o NavigationServer sincronizar o mapa
	if NavigationServer3D.map_get_iteration_id(
		navigation_agent.get_navigation_map()
	) == 0:
		return Vector3.ZERO

	if navigation_agent.is_navigation_finished():
		return Vector3.ZERO

	var next_path_position := navigation_agent.get_next_path_position()

	var direction := source.global_position.direction_to(
		next_path_position
	)
	
	var distance := target.global_position.distance_to(source.global_position)
	if distance <= follow_distance:
		return Vector3.ZERO

	direction.y = 0

	return direction.normalized()
