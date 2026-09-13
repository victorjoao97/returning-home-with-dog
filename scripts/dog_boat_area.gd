extends Area3D
@onready var input_component: InputComponent = %InputComponent
@onready var dog_boat: Node3D = %DogBoat

var _body_entered: Node3D

func _process(_delta: float) -> void:
	if _body_entered != null and input_component.is_interact_pressed:
		_body_entered.set_meta("dog_boat", true)
		dog_boat.get_node("OmniLight3D").queue_free.call_deferred()
		dog_boat.reparent(_body_entered, false)
		dog_boat.hide()
		monitoring = false

func _on_body_entered(_body: Node3D) -> void:
	_body_entered = _body

func _on_body_exited(_body: Node3D) -> void:
	_body_entered = null
