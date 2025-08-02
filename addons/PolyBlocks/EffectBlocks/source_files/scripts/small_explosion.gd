extends Node3D

@onready var fire: GPUParticles3D = $Fire
@onready var sparks: GPUParticles3D = $Sparks
@onready var smoke: GPUParticles3D = $Smoke
@onready var audio: AudioStreamPlayer3D = $Audio

@export var auto_animate: bool = false
@export var cooldown: float = 2.0
var time_since_last_explosion: float = 0.0

func _process(delta):
	time_since_last_explosion += delta

	if auto_animate:
		if time_since_last_explosion >= cooldown:
			explosion()
	else:
		if Input.is_action_just_pressed("ui_accept") and time_since_last_explosion >= cooldown:
			explosion()

func explosion():
	fire.emitting = true
	sparks.emitting = true
	smoke.emitting = true
	audio.play()
	time_since_last_explosion = 0.0
