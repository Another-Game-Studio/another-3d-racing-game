extends Marker3D

@export var player_vehicle : RigidBody3D
@export var move_speed : float = 5.0
@export var world : Node3D
var markers : Array[Marker3D] = []
var grace_period_ended : bool = false
var spawn_cooldown : bool = false
# Called when the node enters the scene tree for the first time.

var rng : RandomNumberGenerator

const pieges : Dictionary[String, PackedScene] = {
	"barrel" : preload("res://scenes/obstacles/ExplosiveBarrel.tscn"),
	"ramp" : preload("res://scenes/obstacles/ramp.glb"),
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
		global_position = global_position.lerp(player_vehicle.global_position, delta*move_speed)
		if grace_period_ended and spawn_cooldown:
			var marker : Marker3D = choose_point()
			var collision_area : Area3D = marker.find_child("Area3D", false)
			if collision_area.get_overlapping_bodies().size()==0 and spawn_cooldown:
				spawn_piege(marker)
		spawn_cooldown = false

func choose_point() -> Node3D:
	return get_child(rng.randi_range(0, get_child_count()-3))

func get_spawn_chances() -> float:
	return 0.3

func spawn_piege(spawn_pos : Marker3D) -> void:
	if !is_inside_tree():
		pass
	if rng.randf() < get_spawn_chances():
		var new_barrel : RigidBody3D = pieges["barrel"].instantiate()
		world.add_child(new_barrel)
		new_barrel.global_position = spawn_pos.global_position

func _on_vehicle_controller_ready() -> void:
	player_vehicle = $"../VehicleController/MyVehicleRigidBody"
	print(player_vehicle)
