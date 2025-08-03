extends Area3D

@onready var game_over_scene: PackedScene = preload("res://scenes/gameover.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body is PhysicsBody3D:
		if body.get_collision_layer_value(1):
			call_deferred("_go_to_game_over")

func _go_to_game_over() -> void:
	get_tree().change_scene_to_packed(game_over_scene)
