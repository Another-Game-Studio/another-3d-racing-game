extends Marker3D

var player_vehicle : RigidBody3D
@export var move_speed : float = 5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_vehicle = $"../VehicleController/MyVehicleRigidBody"
	if not player_vehicle:
		print("En attente")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if player_vehicle:
		global_position = global_position.lerp(player_vehicle.global_position, delta*move_speed)


func _on_vehicle_controller_ready() -> void:
	player_vehicle = $"../VehicleController/MyVehicleRigidBody"
	print(player_vehicle)
