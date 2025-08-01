extends GPUParticles3D

@onready var lightning: GPUParticles3D = $"."  # Refers to itself

@export var auto_animate: bool = false
@export var cooldown_time: float = 2.0

var _timer: float = 0.0

func _process(delta: float) -> void:
	if auto_animate:
		_timer -= delta
		if _timer <= 0.0:
			lightning.emitting = true
			_timer = cooldown_time
	else:
		if Input.is_action_just_pressed("ui_accept"):
			lightning.emitting = true
