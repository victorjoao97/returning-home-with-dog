extends State

@export var dog_escape_sequence: DogEscapeSequence
@export var mailman: Mailman
@export var next_scene: PackedScene

@onready var gate: GateHome = %Gate
@onready var mailman_path_follow_3d: PathFollow3D = %MailmanPathFollow3D

func enter() -> void:
	await gate.open_gate()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(mailman_path_follow_3d, "progress_ratio", 0, 5)
	mailman.running()
	mailman.rotate_y(PI)
	dog_escape_sequence.start()
	await tween.finished
	mailman.queue_free.call_deferred()
	
	dog_escape_sequence.finished.connect(_on_dog_escape_sequence_finished)

func _on_dog_escape_sequence_finished() -> void:
	print("finished")
	get_tree().change_scene_to_packed.call_deferred(next_scene)
