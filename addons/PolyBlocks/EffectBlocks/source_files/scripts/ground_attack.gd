extends Node3D

@onready var spikes: GPUParticles3D = $Spikes
@onready var sparks: GPUParticles3D = $Sparks
@onready var crack: Decal = $Crack

func ground_attack():
	spikes.emitting = true
	sparks.emitting = true
	crack.emission_energy = 0.0

	await get_tree().create_timer(0.2).timeout
	crack.emission_energy = 16.0

	await get_tree().create_timer(1.0).timeout

	var duration := 2.0
	var steps := 20
	for i in range(steps + 1):
		var t := i / float(steps)
		crack.emission_energy = lerp(16.0, 0.0, t)
		await get_tree().create_timer(duration / steps).timeout
