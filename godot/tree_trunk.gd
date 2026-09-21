extends RigidBody3D

@onready var tree_trunk_area: Area3D = $TreeTrunkArea

var entered: Player
var carrying := false

@export var push_force := 20.0

func push(direction: Vector3) -> void:
	if not carrying or not entered:
		linear_velocity = Vector3.ZERO
		return

	direction = direction.normalized()

	apply_central_force(direction)

func _ready() -> void:
	tree_trunk_area.body_entered.connect(_on_body_entered)
	tree_trunk_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		entered = body


func _on_body_exited(body: Node3D) -> void:
	if body == entered:
		entered = null
		carrying = false
		linear_velocity = Vector3.ZERO


func _physics_process(_delta: float) -> void:
	carrying = entered and Input.is_action_pressed("carry")

	if not carrying or not entered:
		linear_velocity = Vector3.ZERO
		return
