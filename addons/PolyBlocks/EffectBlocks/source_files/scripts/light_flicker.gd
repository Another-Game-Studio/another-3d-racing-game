extends OmniLight3D

@export_category("Flickering Properties")
@export var animate_flickering: bool = true
@export_range(0.1, 1.0) var min_intensity: float = 0.8
@export_range(1.0, 3.0) var max_intensity: float = 1.2
@export_range(0.01, 1.0) var flicker_speed: float = 0.5

@export_category("Size Properties")
@export var animate_size: bool = true
@export_range(0.1, 1.0) var min_size: float = 0.8
@export_range(1.0, 2.0) var max_size: float = 1.2
@export_range(0.01, 1.0) var size_change_speed: float = 0.01

@export_category("Movement Properties")
@export var animate_movement: bool = true
@export_range(0.0, 0.2) var movement_radius: float = 0.1
@export_range(0.01, 1.0) var movement_speed: float = 0.5

var base_intensity: float
var base_size: float
var original_position: Vector3
var time_passed: float = 0.0

func _ready():
	base_intensity = light_energy
	base_size = omni_range
	original_position = position
	
	# Randomize initial time offset for varied behavior when multiple lights are used
	time_passed = randf() * 100.0

func _process(delta):
	time_passed += delta
	

	_update_intensity()
	_update_size()
	_update_position()

func _update_intensity():
	if not animate_flickering:
		return

	var flicker_value = (
		sin(time_passed * 10.0 * flicker_speed) * 0.4 + 
		sin(time_passed * 17.3 * flicker_speed) * 0.3 +
		sin(time_passed * 5.7 * flicker_speed) * 0.3
	)
	
	light_energy = base_intensity * (1.0 + flicker_value * 0.5)
	light_energy = clamp(light_energy, base_intensity * min_intensity, base_intensity * max_intensity)

func _update_size():
	if not animate_size:
		return
	
	var size_value = (
		sin(time_passed * 8.7 * size_change_speed) * 0.5 + 
		sin(time_passed * 12.9 * size_change_speed) * 0.3 +
		sin(time_passed * 4.2 * size_change_speed) * 0.2
	)
	
	omni_range = base_size * (1.0 + size_value * 0.5)
	omni_range = clamp(omni_range, base_size * min_size, base_size * max_size)

func _update_position():
	if not animate_movement or movement_radius <= 0:
		return

	var x_offset = sin(time_passed * 8.3 * movement_speed) * movement_radius
	var y_offset = sin(time_passed * 7.9 * movement_speed) * movement_radius
	var z_offset = sin(time_passed * 9.4 * movement_speed) * movement_radius
	
	position = original_position + Vector3(x_offset, y_offset, z_offset)
