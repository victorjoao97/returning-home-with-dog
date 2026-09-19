class_name Player extends CharacterBody3D

const SPEED := 3.0
const JUMP_VELOCITY := 4.5
const GRAVITY := -12.0
const COYOTE_TIME := 0.15

var coyote_timer: float = 0.0
var last_direction := Vector3.FORWARD

func _physics_process(delta: float) -> void:
	# Atualiza timer de coyote time
	if not is_on_floor():
		coyote_timer -= delta
	
	# Reseta timer ao tocar o chão (IMPORTANTE!)
	elif is_on_floor():
		coyote_timer = COYOTE_TIME
	
	# Aplicar gravidade
	velocity.y += GRAVITY * delta
	
	# Lidar com pulo - permite pular se estiver no chão OU durante coyote time
	if Input.is_action_just_pressed("jump") and coyote_timer >= 0.0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0  # Reseta ao pular para evitar múltiplos pulos
	
	# Processar movimento lateral
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_dir:
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
		direction = direction.rotated(Vector3.UP, get_viewport().get_camera_3d().global_rotation.y)
		last_direction = direction.normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 20.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 20.0)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body is RigidBody3D:
			body.apply_central_impulse(-collision.get_normal() * 2.0)
	
	move_and_slide()
