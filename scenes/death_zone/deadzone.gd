extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is PhysicsBody3D:
		if body.get_collision_layer_value(1):
			SignalBus.car_fell.emit()
