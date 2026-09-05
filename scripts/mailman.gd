class_name Mailman extends Character
@onready var package: CSGBox3D = $Package

func remove_box() -> void:
	if package:
		package.queue_free.call_deferred()
