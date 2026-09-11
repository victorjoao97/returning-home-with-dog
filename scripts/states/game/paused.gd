extends State
@export var input_component: InputComponent
@export var in_house: State
@export var dog_area: Area3D
@onready var mailman_area: Area3D = %MailmanArea
@onready var animation_player: AnimationPlayer = $"../../PlayerGroup/Dog/DogGlb/AnimationPlayer"

var enabled := false
var dog_area_entered := false

func _ready() -> void:
	dog_area.body_entered.connect(_on_dog_area_entered)
	dog_area.body_exited.connect(_on_dog_area_exit)

func enter() -> void:
	mailman_area.hide()
	enabled = true
	animation_player.play("Dog1_Lay")

func exit() -> void:
	enabled = false
	dog_area.body_entered.disconnect(_on_dog_area_entered)
	dog_area.body_exited.disconnect(_on_dog_area_exit)
	dog_area.monitoring = false
	mailman_area.show()
	mailman_area.monitoring = false

func physics_update(_delta: float) -> void:
	if !enabled:
		return
	
	if input_component.is_interact_pressed and dog_area_entered:
		switch_state.emit(in_house)

func _on_dog_area_entered(_body: Node3D) -> void:
	dog_area_entered = true
	animation_player.play("Dog1_Sit")

func _on_dog_area_exit(_body: Node3D) -> void:
	dog_area_entered = false
	animation_player.play("Dog1_Lay_Start")
