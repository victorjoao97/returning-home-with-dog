extends Node3D
@onready var animation_player: AnimationPlayer = $Dog/DogGlb/AnimationPlayer


func _on_follow_component_following() -> void:
	animation_player.play("Dog1_Run")


func _on_follow_component_stopped() -> void:
	animation_player.play("Dog1_Idle")


func _on_floor_body_entered(_body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()


func _on_area_3d_body_entered(body: Node3D) -> void:
	body.position.y = 20
