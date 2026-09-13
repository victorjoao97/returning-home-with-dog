extends Area3D
@onready var input_component: InputComponent = %InputComponent
@onready var dog: Dog = %Dog
@onready var navigation_region_3d: NavigationRegion3D = %NavigationRegion3D

var _body_entered: Node3D

func _process(_delta: float) -> void:
	if _body_entered != null and input_component.is_interact_pressed and _body_entered.has_meta("dog_boat"):
		print("dropped dog boat")
		var dog_boat: Node3D = _body_entered.get_node("DogBoat")
		dog_boat.reparent(get_tree().root)
		dog_boat.global_position = global_position
		dog_boat.rotation = Vector3.ZERO
		dog_boat.show()
		navigation_region_3d.enabled = false
		dog.global_position = dog_boat.global_position
		dog.rotation.x = 60
		dog.reparent(dog_boat)
		monitoring = false
		
		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(dog_boat, "global_position:z", 40, 10).as_relative()
		tween.tween_property(dog_boat, "global_position:x", -5, 3).as_relative()
		tween.tween_property(dog_boat, "global_position:y", 1, 3).as_relative()

func _on_body_entered(body: Node3D) -> void:
	_body_entered = body


func _on_body_exited(body: Node3D) -> void:
	_body_entered = null
