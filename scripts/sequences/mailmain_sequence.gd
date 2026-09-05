class_name MailmanSequence
extends Sequence

@export var mailman_area: Area3D
@export var mailman: Mailman
@onready var mailman_path_follow_3d: PathFollow3D = %MailmanPathFollow3D

var mailman_entered := false

func _ready() -> void:
	mailman_area.body_entered.connect(_on_mailman_area_body_entered)
	mailman_area.body_exited.connect(_on_mailman_area_body_exited)

func _physics_process(_delta: float) -> void:
	if _is_mail_man_finished():
		_on_gate_animation_finished()

func _is_mail_man_finished() -> bool:
	return mailman_path_follow_3d.progress_ratio == 1.0

func start() -> void:
	mailman_area.monitoring = true
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(mailman_path_follow_3d, "progress_ratio", 1, 3)

func _on_mailman_area_body_entered(_body: Node3D) -> void:
	mailman_entered = true


func _on_mailman_area_body_exited(_body: Node3D) -> void:
	mailman_entered = false


func try_interact() -> bool:
	if !mailman_entered or !_is_mail_man_finished():
		return false

	mailman_area.monitoring = false

	complete()
	return true

func _on_gate_animation_finished() -> void:
	pass
