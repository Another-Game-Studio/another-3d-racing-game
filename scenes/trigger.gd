extends Area3D

@export var troncon_manager: Node3D

func _on_body_entered(body: Node) -> void:
	if not (body is PhysicsBody3D):
		return
	if body.get_collision_layer_value(1):
		print("TRIGGER")
		if troncon_manager:
			troncon_manager.change_scene()
