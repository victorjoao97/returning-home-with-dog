class_name DogEscapeSequence
extends Sequence

@onready var player: Player = %Player
@onready var change_reality_area: Area3D = %ChangeRealityArea
@onready var world_environment_component: WorldEnvironmentComponent = %WorldEnvironmentComponent

@export var dog: Dog
@export var spawn_dog_outside: Marker3D
@export var start_running: Area3D
@export var mailman: Mailman
@export var car_scene: PackedScene
@export var car_spawner_markers: Array[Marker3D]

var start_car_spawner := false
var car_spawner_timer := 0.0

func start() -> void:
	dog.global_position = spawn_dog_outside.global_position
	dog.global_rotation = spawn_dog_outside.global_rotation

	mailman.remove_box()
	player.add_box()

	start_running.monitoring = true

func _physics_process(_delta: float) -> void:
	if start_car_spawner:
		car_spawner_timer += _delta
		if car_spawner_timer > 2:
			var car: Node3D = car_scene.instantiate()
			var marker: Marker3D = car_spawner_markers.pick_random()
			car.position = marker.global_position
			car.rotation = marker.rotation
			if car.has_method("set_direction"):
				var direction: Vector3 = marker.global_transform.basis.z
				car.set_direction(direction)
			add_child(car)
			car_spawner_timer = 0.0

func _on_start_running_body_entered(_body: Node3D) -> void:
	start_running.set_deferred("monitoring", false)
	dog.start_escape()
	start_car_spawner = true


func _on_stop_dog_area_body_entered(_body: Node3D) -> void:
	dog.stop_escape()


func _on_stop_player_area_body_entered(_body: Node3D) -> void:
	player.stop()
	complete()


func _on_change_reality_area_body_entered(_body: Node3D) -> void:
	print("start change reality")
	world_environment_component.enter_strange_reality()
