extends State
@onready var collision_ahead: RayCast3D = %CollisionAhead
@onready var collision_ground: RayCast3D = %CollisionGround
@onready var movement_component: MovementComponent = %MovementComponent

@export var body: CharacterBody3D
@export var idle_state: State

func physics_update(_delta: float) -> void:
	if (!collision_ground.is_colliding() or collision_ahead.is_colliding()) and body.is_on_floor():
		movement_component.jump()

	movement_component.move(Vector2(1, 0), _delta)
