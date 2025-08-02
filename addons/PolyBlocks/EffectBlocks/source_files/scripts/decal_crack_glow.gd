extends Decal

@export var glow_speed: float = 1.5
@export var max_emission: float = 1.0

func _process(_delta: float) -> void:
	var time := Time.get_ticks_msec() / 1000.0
	emission_energy = (sin(time * glow_speed) + 1.0) / 2.0 * max_emission
