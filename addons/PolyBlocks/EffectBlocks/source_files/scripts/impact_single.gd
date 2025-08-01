extends GPUParticles3D

var can_activate = true
@export var auto_animate: bool = false
@export var cooldown_time: float = 2.0


func _process(_delta: float) -> void:
	if auto_animate and can_activate:
		activate_effects()
	elif Input.is_action_just_pressed("ui_accept") and can_activate:
		activate_effects()


func activate_effects() -> void:
	can_activate = false

	# Start particle emission
	self.emitting = true

	# Start cooldown timer
	var timer: SceneTreeTimer = get_tree().create_timer(cooldown_time)
	timer.timeout.connect(_on_cooldown_timeout)


func _on_cooldown_timeout() -> void:
	can_activate = true
