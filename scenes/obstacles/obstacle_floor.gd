extends Area3D

var game_manager: Node = null

func _ready() -> void:
	game_manager = get_tree().get_root().find_child("GameManager", true, false)

func _on_body_entered(body: Node) -> void:
	if not (body is PhysicsBody3D):
		return

	if body.get_collision_layer_value(1):
		if game_manager:
			game_manager.lose_life()
