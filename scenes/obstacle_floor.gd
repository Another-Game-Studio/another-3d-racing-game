extends Area3D

@export var game_manager: Node

func _on_body_entered(body: Node) -> void:
	if not (body is PhysicsBody3D):
		return

	if body.get_collision_layer_value(1):
		if game_manager:
			game_manager.lose_life()
