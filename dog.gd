extends CharacterBody3D

@onready var player: Player = %Player

const SPEED := 4.0
const GRAVITY := -12.0
const MIN_DISTANCE := 3.5

var needs_following := true

func _physics_process(delta: float) -> void:
	if not needs_following:
		return

	var follow_position := player.global_position - player.last_direction * MIN_DISTANCE

	var distance := global_position.distance_to(follow_position)

	if distance < 1.0:
		velocity.x = 0.0
		velocity.z = 0.0
	else:
		var direction := global_position.direction_to(follow_position)
		direction.y = 0.0
		direction = direction.normalized()

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0

	move_and_slide()


func _on_game_dog_following() -> void:
	needs_following = !needs_following
