class_name Mailman extends Character
@onready var package: CSGBox3D = $Package
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func remove_box() -> void:
	if package:
		package.queue_free.call_deferred()

func running() -> void:
	animation_player.play("run/Root|Run")

func stop() -> void:
	animation_player.play("idle/Root|Idle")
