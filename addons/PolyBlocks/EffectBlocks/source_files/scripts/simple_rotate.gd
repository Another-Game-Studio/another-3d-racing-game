extends MeshInstance3D

@export var rotation_speed: float = 15.0

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotation_speed * delta))
