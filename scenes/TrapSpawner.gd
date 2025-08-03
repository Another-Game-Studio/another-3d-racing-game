extends Marker3D

@export var player_vehicle : RigidBody3D
@export var move_speed : float = 5.0
var markers : Array[Marker3D] = []
var grace_period_ended : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player_vehicle:
		print("En attente")
	for child : Node in get_children():
		if child is Marker3D:
			markers.append(child as Marker3D)
	$Timer.timeout.connect(_on_grace_period_timeout)


func _on_grace_period_timeout() -> void:
	grace_period_ended = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if player_vehicle:
		global_position = global_position.lerp(player_vehicle.global_position, delta*move_speed)
		if grace_period_ended:
			for marker : Marker3D in markers :
				var collision_area : Area3D = marker.find_child("Area3D", false)
				if collision_area.get_overlapping_bodies().size()==0:
					print(str(marker)+" can spawn trap")


func _on_vehicle_controller_ready() -> void:
	player_vehicle = $"../VehicleController/MyVehicleRigidBody"
	print(player_vehicle)
