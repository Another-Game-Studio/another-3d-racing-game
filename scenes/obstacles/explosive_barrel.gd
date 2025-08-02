extends RigidBody3D

const Explosion : PackedScene = preload("res://addons/PolyBlocks/EffectBlocks/assets/explosions/explosion_small.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func explode() -> void:
	var explosion : Node3D = Explosion.instantiate()
	add_child(explosion)
	explosion.explosion()
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if not(body is RigidBody3D):
		pass
	print("Body entered:"+str(body))
	if body.get_collision_layer_value(1):
		explode()
