extends RigidBody3D

const Explosion: PackedScene = preload("res://addons/PolyBlocks/EffectBlocks/assets/explosions/explosion_small.tscn")

var local_collision_pos: Vector3 = Vector3(0, 0, 0)
var game_manager: Node = null

func _ready() -> void:
	game_manager = get_tree().get_root().find_child("GameManager", true, false)

func _process(delta: float) -> void:
	pass

func explode() -> void:
	var explosion: Node3D = Explosion.instantiate()
	add_child(explosion)
	explosion.explosion()
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if not (body is RigidBody3D):
		return

	if body.get_collision_layer_value(1):
		var explosion_vector: Vector3 = global_position - body.global_position
		var explosion_power: float = -20000.0
		body.apply_central_impulse(explosion_vector * explosion_power)
		if game_manager:
			game_manager.lose_life()
		explode()
