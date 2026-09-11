extends Node3D
@onready var animation_player: AnimationPlayer = $Dog/DogGlb/AnimationPlayer


func _on_follow_component_following() -> void:
	animation_player.play("Dog1_Run")


func _on_follow_component_stopped() -> void:
	animation_player.play("Dog1_Idle")
