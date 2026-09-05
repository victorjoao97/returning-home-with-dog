class_name WorldEnvironmentComponent extends Node

@export var world_environment: WorldEnvironment
@export var directional_light: DirectionalLight3D

var normal := {
	"fog_density": 0.0,
	"fog_color": Color.WHITE,
	"ambient_energy": 1.0,
	"light_energy": 1.0,
	"light_color": Color.WHITE,
	"exposure": 1.0,
	"rotation": Vector3(-50.0, -30.0, 0.0)
}

var strange_1 := {
	"fog_density": 0.12,
	"fog_color": Color(0.12, 0.18, 0.28),
	"ambient_energy": 0.08,
	"light_energy": 0.25,
	"light_color": Color(0.35, 0.55, 1.0),
	"exposure": 0.45,
	"rotation": Vector3(-15.0, 120.0, 0.0)
}

var strange_2 := {
	"fog_density": 0.25,
	"fog_color": Color(0.25, 0.08, 0.32),
	"ambient_energy": 0.05,
	"light_energy": 0.15,
	"light_color": Color(0.7, 0.25, 1.0),
	"exposure": 0.25,
	"rotation": Vector3(-5.0, 200.0, 0.0)
}

var strange_3 := {
	"fog_density": 0.05,
	"fog_color": Color(0.35, 0.3, 0.12),
	"ambient_energy": 0.3,
	"light_energy": 0.5,
	"light_color": Color(1.0, 0.55, 0.25),
	"exposure": 0.7,
	"rotation": Vector3(-65.0, 280.0, 0.0)
}


func _ready() -> void:
	apply_state(normal)


func enter_strange_reality() -> void:
	while true:
		await transition_to(strange_1, 3.0)
		await transition_to(strange_2, 4.0)
		await transition_to(strange_3, 3.0)
		await transition_to(strange_1, 5.0)


func transition_to(state: Dictionary, duration: float) -> void:
	var env := world_environment.environment

	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		env,
		"fog_density",
		state.fog_density,
		duration
	)

	tween.tween_property(
		env,
		"fog_light_color",
		state.fog_color,
		duration
	)

	tween.tween_property(
		env,
		"ambient_light_energy",
		state.ambient_energy,
		duration
	)

	tween.tween_property(
		env,
		"tonemap_exposure",
		state.exposure,
		duration
	)

	tween.tween_property(
		directional_light,
		"light_energy",
		state.light_energy,
		duration
	)

	tween.tween_property(
		directional_light,
		"light_color",
		state.light_color,
		duration
	)

	tween.tween_property(
		directional_light,
		"rotation_degrees",
		state.rotation,
		duration
	)

	await tween.finished


func apply_state(state: Dictionary) -> void:
	var env := world_environment.environment

	env.fog_density = state.fog_density
	env.fog_light_color = state.fog_color
	env.ambient_light_energy = state.ambient_energy
	env.tonemap_exposure = state.exposure

	directional_light.light_energy = state.light_energy
	directional_light.light_color = state.light_color
	directional_light.rotation_degrees = state.rotation
