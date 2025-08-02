extends Camera3D

@export var follow_distance = 5
@export var follow_height = 2
@export var camera_y_offset := 1.0
@export var speed := 20.0
@export var follow_this : Node3D

var start_rotation : Vector3
var start_position : Vector3
var shake_strength: float = 0.0
var shake_decay: float = 5.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var original_position: Vector3

func _ready():
	start_rotation = rotation
	start_position = position
	original_position = position
	rng.randomize()

func _physics_process(delta : float):
	var delta_v: Vector3 = global_transform.origin - follow_this.global_transform.origin
	delta_v.y = 0.0
	if delta_v.length() > follow_distance:
		delta_v = delta_v.normalized() * follow_distance
		delta_v.y = follow_height
		global_position = follow_this.global_transform.origin + delta_v + Vector3.UP * camera_y_offset

	var offset: Vector3 = Vector3.ZERO
	if shake_strength > 0.01:
		shake_strength = lerp(shake_strength, 0.0, delta * shake_decay)
		offset.x = rng.randf_range(-shake_strength, shake_strength)
		offset.y = rng.randf_range(-shake_strength, shake_strength)

	global_position += offset

	look_at(follow_this.global_transform.origin + Vector3.UP * camera_y_offset, Vector3.UP)

func trigger_shake(strength: float) -> void:
	shake_strength = strength
