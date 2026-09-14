class_name Puzzle01 extends Node

@export var get_paddle_area: Area3D
@export var paddle: Node3D
@export var canoe: Node3D
@export var dog: Dog
@export var follow_target_component: FollowTargetComponent
@export var player: Player
@export var boat_area: Area3D
@export var canoe_run: Node3D
@export var final_boat_marker: Marker3D
@export var lightning_animation_player: AnimationPlayer

enum State {
	WAIT,
	PADDLE_OFF,
	PADDLE_ON,
	BOAT_OFF,
	BOAT_ON,
	WAIT_BOAT,
	BOAT_AREA,
	BOAT_RUN,
	FINAL
}

var current_state := State.WAIT

func _ready() -> void:
	get_paddle_area.body_entered.connect(_on_entered_paddle_area)
	get_paddle_area.body_exited.connect(_on_exited_paddle_area)
	boat_area.body_entered.connect(_on_entered_boat_area)
	boat_area.body_exited.connect(_on_exited_boat_area)
	canoe_run.hide()
	canoe_run.process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta: float) -> void:
	if current_state == State.WAIT:
		return
	var interacted := Input.is_action_just_pressed("interact")
	
	if current_state == State.PADDLE_ON and interacted:
		follow_target_component.enable_fixed_z = false
		follow_target_component.enable_stop_distance = false
		follow_target_component.target = paddle
		await follow_target_component.target_reached
		paddle.hide()
		current_state = State.WAIT_BOAT
		follow_target_component.enable_fixed_z = true
		follow_target_component.enable_stop_distance = true
		follow_target_component.target = player
	if current_state == State.BOAT_AREA and interacted:
		player.queue_free.call_deferred()
		dog.queue_free.call_deferred()
		canoe.hide()
		canoe_run.process_mode = Node.PROCESS_MODE_INHERIT
		canoe_run.show()
		current_state = State.BOAT_ON
	if current_state == State.BOAT_ON:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(
			canoe_run,
			"global_position",
			final_boat_marker.global_position,
			60
		)
		current_state = State.BOAT_RUN
		lightning()
		await tween.finished
		current_state = State.FINAL
	if current_state == State.FINAL:
		process_mode = Node.PROCESS_MODE_DISABLED

func lightning() -> void:
	lightning_animation_player.play("lightning")

func _on_entered_paddle_area(_body: Node3D) -> void:
	if current_state != State.WAIT:
		return
	current_state = State.PADDLE_ON

func _on_exited_paddle_area(_body: Node3D) -> void:
	if current_state != State.PADDLE_ON:
		return
	current_state = State.PADDLE_OFF

func _on_entered_boat_area(_body: Node3D) -> void:
	if current_state != State.WAIT_BOAT:
		return
	current_state = State.BOAT_AREA

func _on_exited_boat_area(_body: Node3D) -> void:
	if current_state != State.BOAT_AREA:
		return
	current_state = State.WAIT_BOAT
