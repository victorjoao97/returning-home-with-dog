class_name Player extends Character
@onready var package: CSGBox3D = $Package

var disable_phisics := false

func add_box() -> void:
	package.show()

func stop() -> void:
	pass

@export var model: Node3D

@export var speed := 5.0
@export var acceleration := 10.0
@export var deceleration := 15.0
@export var jump_velocity := 8.0
@export var gravity := 20.0
@export var rotation_speed := 10.0

var velocity_x := 0.0
var vertical_velocity := 0.0


func _physics_process(delta):
	if disable_phisics:
		return

	var input_x := Input.get_axis("move_left", "move_right")

	# Movimento horizontal
	var target_velocity := input_x * speed

	if input_x != 0:
		velocity_x = move_toward(
			velocity_x,
			target_velocity,
			acceleration * delta
		)

		# Rotaciona o modelo para a direção do movimento
		if model:
			var target_rotation := 0.0

			if input_x > 0:
				target_rotation = 0.0
			else:
				target_rotation = PI

			model.rotation.y = lerp_angle(
				model.rotation.y,
				target_rotation,
				rotation_speed * delta
			)
	else:
		velocity_x = move_toward(
			velocity_x,
			0.0,
			deceleration * delta
		)

	# Gravidade
	if not is_on_floor():
		vertical_velocity -= gravity * delta
	else:
		vertical_velocity = 0.0

		if Input.is_action_just_pressed("jump"):
			vertical_velocity = jump_velocity

	# Aplica movimento
	velocity.x = velocity_x
	velocity.y = vertical_velocity
	velocity.z = 0.0

	move_and_slide()
