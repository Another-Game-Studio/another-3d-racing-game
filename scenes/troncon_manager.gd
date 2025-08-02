extends Node3D

@export var new_scene: PackedScene

func change_scene() -> void:
	if new_scene:
		var instance: Node3D = new_scene.instantiate()
		add_child(instance)
