extends CharacterBody3D

var direction: Vector3

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta

		if velocity.y < -20.0:
			queue_free.call_deferred()

	velocity.x = direction.x * 10.0
	velocity.z = direction.z * 10.0

	move_and_slide()


func set_direction(_direction: Vector3) -> void:
	direction = _direction.normalized()
