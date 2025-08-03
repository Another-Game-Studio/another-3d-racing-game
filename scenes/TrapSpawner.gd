extends Marker3D

@export var player_vehicle : RigidBody3D
@export var move_speed : float = 5.0
@export var world : Node3D
var markers : Array[Marker3D] = []
var grace_period_ended : bool = false
var spawn_cooldown : bool = false
# Called when the node enters the scene tree for the first time.

var min_speed: float = 3.0


var rng : RandomNumberGenerator

const pieges : Dictionary[String, PackedScene] = {
	"barrel" : preload("res://scenes/obstacles/ExplosiveBarrel.tscn"),
	"obstacle_moving" : preload("res://scenes/obstacles/obstacle_moving.tscn"),
	"obstacle" : preload("res://scenes/obstacles/obstacle.tscn")
}


func _ready() -> void:
	if not player_vehicle:
		print("En attente")
	for child : Node in get_children():
		if child is Marker3D:
			markers.append(child as Marker3D)
	$GracePeriod.timeout.connect(_on_grace_period_timeout)
	$SpawnCooldown.timeout.connect(_on_spawn_cooldown_finished)
	rng = RandomNumberGenerator.new()


func _on_spawn_cooldown_finished() -> void:
	spawn_cooldown = true

func _on_grace_period_timeout() -> void:
	grace_period_ended = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if player_vehicle:
		global_position = global_position.lerp(player_vehicle.global_position, delta * move_speed)

		var current_speed: float = player_vehicle.linear_velocity.length()

		if grace_period_ended and spawn_cooldown and current_speed > min_speed:
			var marker: Marker3D = choose_point()
			var collision_area: Area3D = marker.find_child("Area3D", false)
			if collision_area.get_overlapping_bodies().size() == 0:
				spawn_piege(marker)
			spawn_cooldown = false

func choose_point() -> Marker3D:
	var valid_markers: Array[Marker3D] = []
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	for marker: Marker3D in markers:
		var ray_params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
			marker.global_position + Vector3.UP,
			marker.global_position + Vector3.DOWN * 5.0
		)
		ray_params.collision_mask = 2

		var result: Dictionary = space_state.intersect_ray(ray_params)

		if result.size() > 0:
			valid_markers.append(marker)

	if valid_markers.is_empty():
		return markers[0]

	return valid_markers[rng.randi_range(0, valid_markers.size() - 1)]

func get_spawn_chances() -> float:
	return 0.5

func spawn_piege(spawn_pos: Marker3D) -> void:
	if not is_inside_tree():
		return
	
	if rng.randf() < get_spawn_chances():
		var keys: Array[String] = pieges.keys()
		var chosen_key: String = keys[rng.randi_range(0, keys.size() - 1)]
		var scene: PackedScene = pieges[chosen_key]
		
		var instance: Node3D = scene.instantiate()
		world.add_child(instance)
		instance.global_position = spawn_pos.global_position

func _on_vehicle_controller_ready() -> void:
	player_vehicle = $"../VehicleController/MyVehicleRigidBody"
