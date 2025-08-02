extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer

@export var flap_delay_range: Vector2 = Vector2(0.0, 2.0)

func _ready() -> void:
	var delay: float = randf_range(flap_delay_range.x, flap_delay_range.y)
	await get_tree().create_timer(delay).timeout
	anim.play("fly")
