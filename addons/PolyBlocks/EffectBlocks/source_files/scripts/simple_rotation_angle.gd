extends Node3D

@export_range(0.0, 180.0) var rotation_angle_degrees: float = 30.0
@export_range(0.1, 10.0) var rotation_duration: float = 5.0

var _original_basis: Basis
var _time_passed := 0.0

func _ready():
	_original_basis = global_transform.basis

func _process(delta: float):
	_time_passed += delta

	# Calculate normalized oscillation time (0 to 1 to 0 to 1...)
	var phase := sin(_time_passed * TAU / rotation_duration)
	
	# Convert angle to radians and apply to the original basis
	var angle := deg_to_rad(rotation_angle_degrees) * phase
	var rotation_axis := Vector3.UP
	var new_basis := _original_basis.rotated(rotation_axis, angle)

	global_transform.basis = new_basis
