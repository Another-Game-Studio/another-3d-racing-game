extends Node3D

@export var speed: float = 2.0

@onready var trigger: Area3D = $Area3D
@onready var end: Node3D = $end

var game_manager: Node = null
var start_pos: Vector3
var target_pos: Vector3
var going_forward: bool = true

func _ready() -> void:
	game_manager = get_tree().get_root().find_child("GameManager", true, false)
	await get_tree().create_timer(0.2).timeout
	trigger.body_entered.connect(_on_body_entered)
	start_pos = global_position
	target_pos = end.global_position

func _physics_process(delta: float) -> void:
	var direction: Vector3 = (target_pos - global_position).normalized()
	global_position += direction * speed * delta

	if global_position.distance_to(target_pos) < 0.1:
		going_forward = not going_forward
		target_pos = end.global_position if going_forward else start_pos

func _on_body_entered(body: Node) -> void:
	if not (body is PhysicsBody3D):
		return

	if body.get_collision_layer_value(1):
		print("COLLISION")

		var pad: int
		if Input.get_connected_joypads().size() > 0:
			pad = Input.get_connected_joypads()[0]
			Input.start_joy_vibration(pad, 0.6, 0.6, 0.3)

		var cam: Camera3D = get_tree().get_root().find_child("Camera3D", true, false)
		if cam:
			cam.trigger_shake(0.5)

		if game_manager:
			game_manager.lose_life()
