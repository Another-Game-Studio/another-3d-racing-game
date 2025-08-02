extends Area3D

var spin : float = 0.2
var bob_height :  float = 0.2
var bob_speed : float = 5.0
var time : float = 0.0

@onready var start_y : float = global_position.y

func _process(delta : float) -> void:
	rotate(Vector3.UP, spin*delta)
	time+=delta
	var d : float = (sin(time*bob_speed)+1)/2
	global_position.y = start_y + (d * bob_height)

func _on_body_entered(body : Node) -> void:
	if body is PhysicsBody3D:
		if body.get_collision_layer_value(1):
			SignalBus.coin_collected.emit()
			queue_free()
