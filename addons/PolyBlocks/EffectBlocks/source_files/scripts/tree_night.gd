extends MeshInstance3D

@export var transition_duration: float = 4.0
@export var day_duration: float = 12.0
@export var night_duration: float = 12.0
@export var start_time: float = 0.0

func _process(_delta):
	var total_cycle = 2.0 * transition_duration + day_duration + night_duration
	var time = fmod(Time.get_ticks_msec() / 1000.0 + start_time * total_cycle, total_cycle)

	var night_time := 0.0

	if time < transition_duration:
		night_time = 1.0 - (time / transition_duration)
	elif time < transition_duration + day_duration:
		night_time = 0.0
	elif time < 2.0 * transition_duration + day_duration:
		night_time = (time - (transition_duration + day_duration)) / transition_duration
	else:
		night_time = 1.0

	var material = get_surface_override_material(1)
	if material:
		material.set_shader_parameter("nightTime", night_time)
